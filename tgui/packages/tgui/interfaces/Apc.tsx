import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Section, Box, Button, BlockQuote, LabeledList, ProgressBar } from '../components';
import { Window } from '../layouts';

export type APCData = {
  locked: BooleanLike;
  power_cell_inserted: BooleanLike;
  power_cell_charge: number;
  fail_time: number;
  silicon_user: BooleanLike;
  total_load: number;
  total_charging: number;
  is_operating: BooleanLike;
  external_power: number;
  charge_mode: BooleanLike;
  main_status: number;
  lighting_mode: BooleanLike;
  charging_status: number;
  cover_locked: BooleanLike;
  emergency_mode: BooleanLike;
  time: number;
  power_channels: PowerChannel[];
};

type PowerChannel = {
  name: string;
  power_load: number;
  status: number;
};

export const Apc = (props, context) => {
  const { act, data } = useBackend<APCData>(context);

  return (
    <Window resizable theme="hephaestus">
      <Window.Content scrollable>
        {data.fail_time > 0 ? <FailWindow /> : <APCWindow />}
      </Window.Content>
    </Window>
  );
};

export const FailWindow = (props, context) => {
  const { act, data } = useBackend<APCData>(context);

  return (
    <Section
      title="SYSTEM FAILURE"
      buttons={
        <Button
          content="Reboot Now"
          icon="sync"
          color="bad"
          onClick={() => act('reboot')}
        />
      }>
      <Box color="red">
        I/O regulator malfuction detected! Waiting for system reboot...
      </Box>
      <BlockQuote>Automatic reboot in {data.fail_time} seconds...</BlockQuote>
    </Section>
  );
};

export const APCWindow = (props, context) => {
  const { act, data } = useBackend<APCData>(context);
  return (
    <Section>
      {data.silicon_user ? (
        <SiliconWindow />
      ) : (
        <BlockQuote>
          Swipe an ID card to {data.locked ? 'un' : ''}lock this interface.
        </BlockQuote>
      )}
      <Section title="Power Status">
        <LabeledList>
          <LabeledList.Item label="Main Breaker">
            {data.locked && !data.silicon_user ? (
              <Box color={data.is_operating ? 'good' : 'bad'}>
                {data.is_operating ? 'On' : 'Off'}
              </Box>
            ) : (
              <Button
                content={data.is_operating ? 'On' : 'Off'}
                icon={data.is_operating ? 'power-off' : 'times'}
                color={data.is_operating ? 'good' : 'bad'}
                onClick={() => act('breaker')}
              />
            )}
          </LabeledList.Item>
          <LabeledList.Item label="External Power">
            {data.external_power === 2 ? (
              <Box color="good">Good</Box>
            ) : data.external_power === 1 ? (
              <Box color="average">Low</Box>
            ) : (
              <Box color="bad">None</Box>
            )}
          </LabeledList.Item>
          <LabeledList.Item label="Power Cell">
            {data.power_cell_inserted ? (
              <ProgressBar
                ranges={{
                  good: [75, 100],
                  average: [30, 75],
                  bad: [0, 30],
                }}
                value={data.power_cell_charge}
                minValue={0}
                maxValue={100}
              />
            ) : (
              <Box color="bad">Power cell removed.</Box>
            )}
          </LabeledList.Item>
          {data.power_cell_inserted ? (
            <LabeledList.Item label="Charge Mode">
              {!data.silicon_user && data.locked ? (
                <Box color={data.charge_mode ? 'good' : 'bad'}>
                  {data.charge_mode ? 'Auto' : 'Off'}
                </Box>
              ) : (
                <Box>
                  <Button
                    content={data.charge_mode ? 'Auto' : 'Off'}
                    icon={data.charge_mode ? 'sync' : 'times'}
                    color={data.charge_mode ? 'good' : ''}
                    onClick={() => act('cmode')}
                  />
                  <Box as="span" color={ChargeClass(data.charging_status)}>
                    [{ChargeStatus(data.charging_status)}]
                  </Box>
                </Box>
              )}
            </LabeledList.Item>
          ) : (
            ''
          )}
          <LabeledList.Item label="Night Lighting">
            <Button
              content={data.lighting_mode ? 'On' : 'Off'}
              icon={data.lighting_mode ? 'moon' : 'sun'}
              color={data.lighting_mode ? 'good' : ''}
              onClick={() =>
                act('lmode', { lmode: data.lighting_mode ? 'off' : 'on' })
              }
            />
          </LabeledList.Item>
          <LabeledList.Item label="Emergency Lighting">
            {!data.silicon_user && data.locked ? (
              <Box>{data.emergency_mode ? 'On' : 'Off'}</Box>
            ) : (
              <Button
                content={data.emergency_mode ? 'On' : 'Off'}
                icon="lightbulb"
                color={data.emergency_mode ? 'good' : ''}
                onClick={() => act('emergency_lights')}
              />
            )}
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="Power Channels">
        <LabeledList>
          {data.power_channels.map((channel) => (
            <LabeledList.Item label={channel.name} key={channel.name}>
              <Box color={channelStatClass(channel.status)}>
                [{channelStatus(channel.status)}] | [
                {channelPower(channel.status)}] | {channel.power_load} W
              </Box>
              {!data.locked && !data.silicon_user ? (
                <Section>
                  <Button
                    content="Auto"
                    icon="sync"
                    color={
                      channel.status === 1 || channel.status === 3 ? 'good' : ''
                    }
                    onClick={() => act('set', { set: 3, chan: channel.name })}
                  />
                  <Button
                    content="On"
                    icon="power-off"
                    color={channel.status === 2 ? 'good' : ''}
                    onClick={() => act('set', { set: 2, chan: channel.name })}
                  />
                  <Button
                    content="Off"
                    icon="times"
                    color={channel.status === 0 ? 'good' : ''}
                    onClick={() => act('set', { set: 1, chan: channel.name })}
                  />
                </Section>
              ) : (
                ''
              )}
            </LabeledList.Item>
          ))}
          <LabeledList.Item label="Total Load">
            {data.total_load}W
            {data.total_charging
              ? ` (+ ${data.total_charging}W Charging)`
              : null}
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="Lock">
        <LabeledList>
          <LabeledList.Item label="Cover Lock">
            {data.locked && !data.silicon_user ? (
              <Box color={data.cover_locked ? 'good' : 'bad'}>
                {data.cover_locked ? 'E' : 'Dise'}ngaged
              </Box>
            ) : (
              <Button
                content={data.cover_locked ? 'Engaged' : 'Disengaged'}
                icon={data.cover_locked ? 'lock' : 'lock-open'}
                color={data.cover_locked ? 'good' : 'bad'}
                onClick={() => act('lock')}
              />
            )}
          </LabeledList.Item>
        </LabeledList>
      </Section>
      {data.silicon_user ? (
        <Section title="System Overrides">
          <Button
            content="Overload Lighting Circuit"
            icon="lightbulb"
            onClick={() => act('overload')}
          />
        </Section>
      ) : (
        ''
      )}
    </Section>
  );
};

export const SiliconWindow = (props, context) => {
  const { act, data } = useBackend<APCData>(context);
  return (
    <Section
      title="Interface Lock"
      buttons={
        <Button
          content={data.locked ? 'Engaged' : 'Disengaged'}
          icon={data.locked ? 'lock' : 'lock-open'}
          color={data.locked ? 'good' : 'bad'}
          onClick={() => act('toggleaccess')}
        />
      }
    />
  );
};

const ChargeStatus = (value) => {
  if (value > 1) {
    return 'Fully Charged';
  } else if (value === 1) {
    return 'Charging';
  } else return 'Not Charging';
};

const ChargeClass = (value) => {
  if (value > 1) {
    return 'good';
  } else if (value === 1) {
    return 'average';
  } else return 'bad';
};

const channelStatus = (channelStat) => {
  if (channelStat <= 1) {
    return 'Off';
  } else return 'On';
};

const channelPower = (channelStat) => {
  if (channelStat === 1 || channelStat === 3) {
    return 'Auto';
  }
  return 'Manual';
};

const channelStatClass = (channelStat) => {
  if (channelStat <= 1) {
    return 'bad';
  }
  return 'good';
};
