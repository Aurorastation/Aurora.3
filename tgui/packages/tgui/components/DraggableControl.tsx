/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { isEscape, KEY } from 'common/keys';
import { clamp } from 'common/math';
import { Component, createRef, type CSSProperties } from 'react';

import { AnimatedNumber } from './AnimatedNumber';

const DEFAULT_UPDATE_RATE = 400;

/**
 * Reduces screen offset to a single number based on the matrix provided.
 */
const getScalarScreenOffset = (e, matrix) => {
  return e.screenX * matrix[0] + e.screenY * matrix[1];
};

type ControlProps = {
  readonly dragMatrix: number[];
  readonly children: any; // Needs rewriting
  readonly value: number;
} & Partial<{
  readonly unclamped: boolean;
  readonly unit: string;
  readonly animated: boolean;
  readonly suppressFlicker: boolean;
  readonly format: (value: number) => string;
  readonly onDrag: (e: any, value: number) => void;
  readonly onChange: (e: any, value: number) => void;
  readonly updateRate: number;
  readonly minValue: number;
  readonly maxValue: number;
  readonly step: number;
  readonly stepPixelSize: number;
  readonly height: number;
  readonly lineHeight: number;
  readonly fontSize: CSSProperties['fontSize'];
}>;

type State = {
  value: number;
  dragging: boolean;
  editing: boolean;
  internalValue: number | null;
  origin: null | number;
  suppressingFlicker: boolean;
};

export class DraggableControl extends Component<ControlProps> {
  inputRef: React.RefObject<HTMLInputElement>;
  state: State;
  flickerTimer: NodeJS.Timeout | null;
  suppressFlicker: () => void;
  handleDragStart: (e: any) => void;
  ref: React.RefObject<HTMLInputElement>;
  timer: NodeJS.Timeout;
  dragInterval: NodeJS.Timeout;
  handleDragMove: (this: Document, ev: MouseEvent) => any;
  handleDragEnd: (this: Document, ev: MouseEvent) => any;
  constructor(props) {
    super(props);
    this.inputRef = createRef();
    this.state = {
      value: props.value,
      dragging: false,
      editing: false,
      internalValue: null,
      origin: null,
      suppressingFlicker: false,
    };

    // Suppresses flickering while the value propagates through the backend
    this.flickerTimer = null;
    this.suppressFlicker = () => {
      const { suppressFlicker } = this.props;
      if (suppressFlicker) {
        this.setState({
          suppressingFlicker: true,
        });
        if (this.flickerTimer) {
          clearTimeout(this.flickerTimer);
        }
        this.flickerTimer = setTimeout(() => {
          this.setState({
            suppressingFlicker: false,
          });
        }, 50);
      }
    };

    this.handleDragStart = (e) => {
      const { value, dragMatrix } = this.props;
      const { editing } = this.state;
      if (editing) {
        return;
      }
      document.body.style['pointer-events'] = 'none';
      this.ref = e.target;
      this.setState({
        dragging: false,
        origin: getScalarScreenOffset(e, dragMatrix),
        value,
        internalValue: value,
      });
      this.timer = setTimeout(() => {
        this.setState({
          dragging: true,
        });
      }, 250);
      this.dragInterval = setInterval(() => {
        const { dragging, value } = this.state;
        const { onDrag } = this.props;
        if (dragging && onDrag) {
          onDrag(e, value);
        }
      }, this.props.updateRate || DEFAULT_UPDATE_RATE);
      document.addEventListener('mousemove', this.handleDragMove);
      document.addEventListener('mouseup', this.handleDragEnd);
    };

    this.handleDragMove = (e) => {
      // prettier-ignore
      const {
        minValue =-Infinity,
        maxValue = +Infinity,
        step = 1,
        stepPixelSize = 1,
        dragMatrix = [1, 0],
      } = this.props;
      this.setState((prevState: State) => {
        const state = { ...prevState };
        const offset = getScalarScreenOffset(e, dragMatrix) - state.origin!;
        if (prevState.dragging) {
          const stepOffset = Number.isFinite(minValue) ? minValue % step : 0;
          // Translate mouse movement to value
          // Give it some headroom (by increasing clamp range by 1 step)
          state.internalValue = clamp(
            state.internalValue! + (offset * step) / stepPixelSize,
            minValue - step,
            maxValue + step,
          );
          // Clamp the final value
          state.value = clamp(
            state.internalValue! - (state.internalValue! % step) + stepOffset,
            minValue,
            maxValue,
          );
          state.origin = getScalarScreenOffset(e, dragMatrix);
        } else if (Math.abs(offset) > 4) {
          state.dragging = true;
        }
        return state;
      });
    };

    this.handleDragEnd = (e) => {
      const { onChange, onDrag } = this.props;
      const { dragging, value, internalValue } = this.state;
      document.body.style['pointer-events'] = 'auto';
      clearTimeout(this.timer);
      clearInterval(this.dragInterval);
      this.setState({
        dragging: false,
        editing: !dragging,
        origin: null,
      });
      document.removeEventListener('mousemove', this.handleDragMove);
      document.removeEventListener('mouseup', this.handleDragEnd);
      if (dragging) {
        this.suppressFlicker();
        if (onChange) {
          onChange(e, value);
        }
        if (onDrag) {
          onDrag(e, value);
        }
      } else if (this.inputRef) {
        const input = this.inputRef.current;
        if (input) {
          input.value = `${internalValue}`;
          setTimeout(() => {
            input.focus();
            input.select();
          }, 1);
        }
      }
    };
  }

  render() {
    const {
      dragging,
      editing,
      value: intermediateValue,
      suppressingFlicker,
    } = this.state;
    const {
      animated,
      value,
      unit,
      minValue,
      maxValue,
      unclamped,
      format,
      onChange,
      onDrag,
      children,
      // Input props
      height,
      lineHeight,
      fontSize,
    } = this.props;
    let displayValue = value;
    if (dragging || suppressingFlicker) {
      displayValue = intermediateValue;
    }
    // prettier-ignore
    const displayElement = (
      <>
        {
          (animated && !dragging && !suppressingFlicker) ?
            (<AnimatedNumber value={displayValue} format={format} />) :
            (format ? format(displayValue) : displayValue)
        }

        { (unit ? ' ' + unit : '') }
      </>
    );

    // Setup an input element
    // Handles direct input via the keyboard
    const inputElement = (
      <input
        ref={this.inputRef}
        className="NumberInput__input"
        style={{
          display: !editing ? 'none' : undefined,
          height: height,
          lineHeight: lineHeight,
          fontSize: fontSize,
        }}
        onBlur={(e) => {
          if (!editing) {
            return;
          }
          let value;
          if (unclamped) {
            value = parseFloat(e.target.value);
          } else {
            value = clamp(parseFloat(e.target.value), minValue, maxValue);
          }
          if (Number.isNaN(value)) {
            this.setState({
              editing: false,
            });
            return;
          }
          this.setState({
            editing: false,
            value,
          });
          this.suppressFlicker();
          if (onChange) {
            onChange(e, value);
          }
          if (onDrag) {
            onDrag(e, value);
          }
        }}
        onKeyDown={(e) => {
          if (e.key === KEY.Enter) {
            let value: number;
            if (unclamped) {
              value = parseFloat((e.target as HTMLInputElement).value);
            } else {
              value = clamp(
                parseFloat((e.target as HTMLInputElement).value),
                minValue,
                maxValue,
              );
            }
            if (Number.isNaN(value)) {
              this.setState({
                editing: false,
              });
              return;
            }
            this.setState({
              editing: false,
              value,
            });
            this.suppressFlicker();
            if (onChange) {
              onChange(e, value);
            }
            if (onDrag) {
              onDrag(e, value);
            }
            return;
          }
          if (isEscape(e.key)) {
            this.setState({
              editing: false,
            });
            return;
          }
        }}
      />
    );
    // Return a part of the state for higher-level components to use.
    return children({
      dragging,
      editing,
      value,
      displayValue,
      displayElement,
      inputElement,
      handleDragStart: this.handleDragStart,
    });
  }
}
