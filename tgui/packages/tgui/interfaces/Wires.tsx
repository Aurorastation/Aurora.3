import type { CSSProperties } from 'react';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { capitalize } from 'tgui-core/string';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
  manufacturer: string;
  proper_name: string;
  wires: Wire[];
  status: string[];
  tamper_resistance: BooleanLike;
};

type Wire = {
  color: string;
  cut: BooleanLike;
  attached: BooleanLike;
  wire: string;
};

const WIRE_COLORS: Record<string, string> = {
  blue: '#2185d0',
  brown: '#a5673f',
  crimson: '#dc143c',
  cyan: '#00ffff',
  gold: '#f1c40f',
  green: '#20b142',
  grey: '#767676',
  lime: '#32cd32',
  magenta: '#ff00ff',
  orange: '#f2711c',
  pink: '#e03997',
  purple: '#a333c8',
  red: '#db2828',
  silver: '#c0c0c0',
  violet: '#6435c9',
  white: '#ffffff',
  yellow: '#fbd608',
};

const LOW_CONTRAST_WIRE_COLORS = new Set([
  'cyan',
  'gold',
  'lime',
  'silver',
  'white',
  'yellow',
]);

type WireButtonStyle = CSSProperties & {
  '--button-color'?: string;
  '--color': string;
};

const getWireColor = (color: string) => WIRE_COLORS[color] ?? color;

const getWireButtonStyle = (color: string): WireButtonStyle => ({
  '--button-color': LOW_CONTRAST_WIRE_COLORS.has(color) ? '#000000' : undefined,
  '--color': getWireColor(color),
});

export const Wires = (props) => {
  const { data } = useBackend<Data>();
  const { proper_name, status = [], wires = [] } = data;
  const dynamicHeight = 150 + wires.length * 30 + (proper_name ? 30 : 0);

  return (
    <Window width={350} height={dynamicHeight} theme={data.manufacturer}>
      <Window.Content>
        <Stack fill vertical>
          {!!proper_name && (
            <Stack.Item>
              <NoticeBox textAlign="center">
                {proper_name} Wire Configuration
              </NoticeBox>
            </Stack.Item>
          )}
          <Stack.Item grow>
            <Section fill>
              <WireMap />
            </Section>
          </Stack.Item>
          {!!status.length && (
            <Stack.Item>
              <Section>
                {status.map((status) => (
                  <Box key={status}>{status}</Box>
                ))}
              </Section>
            </Stack.Item>
          )}
        </Stack>
      </Window.Content>
    </Window>
  );
};

/** Returns a labeled list of wires */
const WireMap = (props) => {
  const { act, data } = useBackend<Data>();
  const { wires } = data;

  return (
    <>
      <LabeledList>
        {wires.map((wire) => {
          const wireColor = getWireColor(wire.color);
          const buttonStyle = getWireButtonStyle(wire.color);

          return (
            <LabeledList.Item
              key={wire.color}
              className="candystripe"
              label={
                <Box as="span" style={{ color: wireColor }}>
                  {capitalize(wire.color)}:
                </Box>
              }
              buttons={
                <>
                  <Button
                    content={wire.cut ? 'Mend' : 'Cut'}
                    style={buttonStyle}
                    onClick={() =>
                      act('cut', {
                        wire: wire.color,
                      })
                    }
                  />
                  <Button
                    content="Pulse"
                    style={buttonStyle}
                    onClick={() =>
                      act('pulse', {
                        wire: wire.color,
                      })
                    }
                  />
                  <Button
                    content={wire.attached ? 'Detach' : 'Attach'}
                    style={buttonStyle}
                    onClick={() =>
                      act('attach', {
                        wire: wire.color,
                      })
                    }
                  />
                </>
              }
            >
              {!!wire.wire && <i style={{ color: wireColor }}>({wire.wire})</i>}
            </LabeledList.Item>
          );
        })}
      </LabeledList>
      {data.tamper_resistance ? (
        <NoticeBox>
          These wires have a tamper-resistant mechanism installed.
        </NoticeBox>
      ) : (
        ''
      )}
    </>
  );
};
