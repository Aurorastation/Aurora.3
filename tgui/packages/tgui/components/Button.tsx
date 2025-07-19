/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import type { Placement } from '@popperjs/core';
import { isEscape, KEY } from 'common/keys';
import { type BooleanLike, classes } from 'common/react';
import {
  type ChangeEvent,
  createRef,
  type MouseEvent,
  type ReactNode,
  useEffect,
  useRef,
  useState,
} from 'react';

import {
  Box,
  type BoxProps,
  computeBoxClassName,
  computeBoxProps,
} from './Box';
import { Icon } from './Icon';
import { Tooltip } from './Tooltip';

/**
 * Getting ellipses to work requires that you use:
 * 1. A string rather than a node
 * 2. A fixed width here or in a parent
 * 3. Children prop rather than content
 */
type EllipsisUnion =
  | {
      ellipsis: true;
      children: string;
      /** @deprecated use children instead */
      content?: never;
    }
  | Partial<{
      ellipsis: undefined;
      children: ReactNode;
      /** @deprecated use children instead */
      content: ReactNode;
    }>;

type Props = Partial<{
  captureKeys: boolean;
  circular: boolean;
  compact: boolean;
  disabled: BooleanLike;
  fluid: boolean;
  icon: string | false;
  iconColor: string;
  iconPosition: string;
  iconRotation: number;
  iconSpin: BooleanLike;
  onClick: (e: any) => void;
  onFocus: (e: any) => void;
  onBlur: (e: any) => void;
  allowAnyClick: BooleanLike;
  selected: BooleanLike;
  tooltip: ReactNode;
  tooltipPosition: Placement;
  verticalAlignContent: string;
}> &
  EllipsisUnion &
  BoxProps;

/** Clickable button. Comes with variants. Read more in the documentation. */
export const Button = (props: Props) => {
  const {
    captureKeys = true,
    children,
    circular,
    className,
    color,
    compact,
    content,
    disabled,
    ellipsis,
    fluid,
    icon,
    iconColor,
    iconPosition,
    iconRotation,
    iconSpin,
    onClick,
    allowAnyClick,
    selected,
    tooltip,
    tooltipPosition,
    verticalAlignContent,
    ...rest
  } = props;

  const toDisplay: ReactNode = content || children;

  let buttonContent = (
    <div
      className={classes([
        'Button',
        fluid && 'Button--fluid',
        disabled && 'Button--disabled',
        selected && 'Button--selected',
        !!toDisplay && 'Button--hasContent',
        circular && 'Button--circular',
        compact && 'Button--compact',
        iconPosition && 'Button--iconPosition--' + iconPosition,
        verticalAlignContent && 'Button--flex',
        verticalAlignContent && fluid && 'Button--flex--fluid',
        verticalAlignContent &&
          'Button--verticalAlignContent--' + verticalAlignContent,
        color && typeof color === 'string'
          ? 'Button--color--' + color
          : 'Button--color--default',
        className,
        computeBoxClassName(rest),
      ])}
      tabIndex={!disabled ? 0 : undefined}
      onClick={(event) => {
        if (!disabled && onClick && (allowAnyClick || event.button === 0)) {
          onClick(event);
        }
      }}
      onKeyDown={(event) => {
        if (!captureKeys) {
          return;
        }

        // Simulate a click when pressing space or enter.
        if (event.key === KEY.Space || event.key === KEY.Enter) {
          event.preventDefault();
          if (!disabled && onClick) {
            onClick(event);
          }
          return;
        }

        // Refocus layout on pressing escape.
        if (isEscape(event.key)) {
          event.preventDefault();
        }
      }}
      {...computeBoxProps(rest)}
    >
      <div className="Button__content">
        {icon && iconPosition !== 'right' && (
          <Icon
            name={icon}
            color={iconColor}
            rotation={iconRotation}
            spin={iconSpin}
          />
        )}
        {!ellipsis ? (
          toDisplay
        ) : (
          <span
            className={classes([
              'Button--ellipsis',
              icon && 'Button__textMargin',
            ])}
          >
            {toDisplay}
          </span>
        )}
        {icon && iconPosition === 'right' && (
          <Icon
            name={icon}
            color={iconColor}
            rotation={iconRotation}
            spin={iconSpin}
          />
        )}
      </div>
    </div>
  );

  if (tooltip) {
    buttonContent = (
      <Tooltip content={tooltip} position={tooltipPosition as Placement}>
        {buttonContent}
      </Tooltip>
    );
  }

  return buttonContent;
};

type CheckProps = Partial<{
  checked: BooleanLike;
}> &
  Props;

/** Visually toggles between checked and unchecked states. */
export const ButtonCheckbox = (props: CheckProps) => {
  const { checked, ...rest } = props;

  return (
    <Button
      color="transparent"
      icon={checked ? 'check-square-o' : 'square-o'}
      selected={checked}
      {...rest}
    />
  );
};

Button.Checkbox = ButtonCheckbox;

type ConfirmProps = Partial<{
  confirmColor: string;
  confirmContent: ReactNode;
  confirmIcon: string;
  onConfirmChange: (clickedOnce: boolean) => void;
}> &
  Props;

/**  Requires user confirmation before triggering its action. */
export const ButtonConfirm = (props: ConfirmProps) => {
  const {
    children,
    color,
    confirmColor = 'bad',
    confirmContent = 'Confirm?',
    confirmIcon,
    ellipsis = true,
    icon,
    onBlur,
    onClick,
    onConfirmChange,
    ...rest
  } = props;
  const [clickedOnce, setClickedOnce] = useState(false);

  function handleBlur(event: FocusEvent) {
    onConfirmChange?.(false);
    setClickedOnce(false);
    onBlur?.(event);
  }

  const handleClick = (
    newState: boolean,
    event: MouseEvent<HTMLDivElement> | undefined,
  ) => {
    if (clickedOnce) {
      if (event && (props.allowAnyClick || event.button === 0)) {
        onClick?.(event);
      }
    }
    setClickedOnce(newState);
    onConfirmChange?.(newState);
  };

  return (
    <Button
      icon={clickedOnce ? confirmIcon : icon}
      color={clickedOnce ? confirmColor : color}
      onBlur={handleBlur}
      onClick={(event: MouseEvent<HTMLDivElement>) => {
        handleClick(!clickedOnce, event);
      }}
      {...rest}
    >
      {clickedOnce && confirmContent ? confirmContent : children}
    </Button>
  );
};

Button.Confirm = ButtonConfirm;

type InputProps = Partial<{
  currentValue: string;
  defaultValue: string;
  fluid: boolean;
  maxLength: number;
  onCommit: (e: any, value: string) => void;
  placeholder: string;
}> &
  Props;

/** Accepts and handles user input. */
const ButtonInput = (props: InputProps) => {
  const {
    children,
    color = 'default',
    content,
    currentValue,
    defaultValue,
    disabled,
    fluid,
    icon,
    iconRotation,
    iconSpin,
    maxLength,
    onCommit = () => null,
    placeholder,
    tooltip,
    tooltipPosition,
    ...rest
  } = props;
  const [inInput, setInInput] = useState(false);
  const inputRef = createRef<HTMLInputElement>();

  const toDisplay = content || children;

  const commitResult = (e) => {
    const input = inputRef.current;
    if (!input) return;

    const hasValue = input.value !== '';
    if (hasValue) {
      onCommit(e, input.value);
    } else {
      if (defaultValue) {
        onCommit(e, defaultValue);
      }
    }
  };

  useEffect(() => {
    const input = inputRef.current;
    if (!input) return;

    if (inInput) {
      input.value = currentValue || '';
      setTimeout(() => {
        input.focus();
        input.select();
      }, 1);
    }
  }, [inInput, currentValue]);

  let buttonContent = (
    <Box
      className={classes([
        'Button',
        disabled && 'Button--disabled',
        fluid && 'Button--fluid',
        'Button--color--' + color,
      ])}
      {...rest}
      onClick={() => {
        if (disabled) return;
        setInInput(true);
      }}
    >
      {icon && <Icon name={icon} rotation={iconRotation} spin={iconSpin} />}
      <div>{toDisplay}</div>
      <input
        disabled={!!disabled}
        ref={inputRef}
        className="NumberInput__input"
        style={{
          display: !inInput ? 'none' : '',
          textAlign: 'left',
        }}
        onBlur={(event) => {
          if (!inInput) {
            return;
          }
          setInInput(false);
          commitResult(event);
        }}
        onKeyDown={(event) => {
          if (event.key === KEY.Enter) {
            setInInput(false);
            commitResult(event);
            return;
          }
          if (isEscape(event.key)) {
            setInInput(false);
          }
        }}
      />
    </Box>
  );

  if (tooltip) {
    buttonContent = (
      <Tooltip content={tooltip} position={tooltipPosition as Placement}>
        {buttonContent}
      </Tooltip>
    );
  }

  return buttonContent;
};

Button.Input = ButtonInput;

type FileProps = {
  readonly accept: string;
  readonly multiple?: boolean;
  readonly onSelectFiles: (files: string | string[]) => void;
} & Props;

/**  Accepts file input */
function ButtonFile(props: FileProps) {
  const { accept, multiple, onSelectFiles, ...rest } = props;

  const inputRef = useRef<HTMLInputElement>(null);

  async function read(files: FileList) {
    const promises = Array.from(files).map((file) => {
      const reader = new FileReader();

      return new Promise<string>((resolve) => {
        reader.onload = () => resolve(reader.result as string);
        reader.readAsText(file);
      });
    });

    return await Promise.all(promises);
  }

  async function handleChange(event: ChangeEvent<HTMLInputElement>) {
    const files = event.target.files;
    if (files?.length) {
      const readFiles = await read(files);
      onSelectFiles(multiple ? readFiles : readFiles[0]);
    }
  }

  return (
    <>
      <Button onClick={() => inputRef.current?.click()} {...rest} />
      <input
        hidden
        type="file"
        ref={inputRef}
        accept={accept}
        multiple={multiple}
        onChange={handleChange}
      />
    </>
  );
}

Button.File = ButtonFile;
