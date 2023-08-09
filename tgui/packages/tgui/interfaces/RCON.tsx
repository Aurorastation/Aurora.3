import { BooleanLike } from '../../common/react';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Collapsible, Input, LabeledList, NoticeBox, NumberInput, ProgressBar, Section } from '../components';
import { NtosWindow } from '../layouts';

export type RCONData = {
  smes_info: SMES[];
  breaker_info: Breaker[];
};

type SMES = {
  charge: number;
  input_set: number;
  input_val: number;
  output_set: number;
  output_val: number;
  input_level_max: number;
  output_level_max: number;
  output_load: number;
  RCON_tag: string;
};

type Breaker = {
  RCON_tag: string;
  enabled: BooleanLike;
  update_locked: BooleanLike;
};

export const RCON = (props, context) => {
  const { act, data } = useBackend<RCONData>(context);

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        {data.smes_info && data.smes_info.length ? (
          <SMESInfo />
        ) : (
          <NoticeBox>No SMES units found.</NoticeBox>
        )}
        {data.breaker_info && data.breaker_info.length ? (
          <BreakerInfo />
        ) : (
          <NoticeBox>No breaker boxes found.</NoticeBox>
        )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const SMESInfo = (props, context) => {
  const { act, data } = useBackend<RCONData>(context);
  const [smesSearchTerm, setSmesSearchTerm] = useLocalState<string>(
    context,
    `smesSearchTerm`,
    ``
  );

  return (
    <Collapsible open>
      <Section
        title="SMES Control"
        buttons={
          <Input
            placeholder="Search by SMES name"
            width="40vw"
            maxLength={512}
            onInput={(e, value) => {
              setSmesSearchTerm(value);
            }}
            value={smesSearchTerm}
          />
        }>
        {data.smes_info
          .filter(
            (s) =>
              s.RCON_tag.toLowerCase().indexOf(smesSearchTerm.toLowerCase()) >
              -1
          )
          .map((smes) => (
            <Section title={smes.RCON_tag} key={smes.RCON_tag}>
              <ProgressBar
                ranges={{
                  good: [75, 100],
                  average: [30, 75],
                  bad: [0, 30],
                }}
                value={smes.charge}
                maxValue={100}
                minValue={0}
              />
              &nbsp;
              <LabeledList>
                <LabeledList.Item label="Input">
                  <NumberInput
                    value={smes.input_val}
                    minValue={0}
                    maxValue={smes.input_level_max}
                    width={8}
                    unit="W"
                    step="50000"
                    stepPixelSize={10}
                    onChange={(e, v) =>
                      act('smes_in_set', {
                        smes_in_set: smes.RCON_tag,
                        value: v,
                      })
                    }
                  />
                  &nbsp;
                  <Button
                    icon="power-off"
                    color={smes.input_set ? 'green' : 'red'}
                    onClick={() =>
                      act('smes_in_toggle', { smes_in_toggle: smes.RCON_tag })
                    }
                  />
                  &nbsp;
                  <Button
                    icon="arrow-circle-right"
                    disabled={smes.input_val === smes.input_level_max}
                    tooltip={
                      smes.input_val === smes.input_level_max
                        ? 'This input is already maxed.'
                        : ''
                    }
                    onClick={() =>
                      act('smes_in_max', { smes_in_max: smes.RCON_tag })
                    }
                  />
                  &nbsp;
                  {smes.input_set ? (
                    <Box color="green" as="span">
                      (AUTO)
                    </Box>
                  ) : (
                    <Box color="red" as="span">
                      (OFF)
                    </Box>
                  )}
                </LabeledList.Item>
                <LabeledList.Item label="Output">
                  <NumberInput
                    value={smes.output_val}
                    minValue={0}
                    maxValue={smes.output_level_max}
                    unit="W"
                    step="50000"
                    width={8}
                    stepPixelSize={10}
                    onChange={(e, v) =>
                      act('smes_out_set', {
                        smes_out_set: smes.RCON_tag,
                        value: v,
                      })
                    }
                  />
                  &nbsp;
                  <Button
                    icon="power-off"
                    color={smes.output_set ? 'green' : 'red'}
                    onClick={() =>
                      act('smes_out_toggle', { smes_out_toggle: smes.RCON_tag })
                    }
                  />
                  &nbsp;
                  <Button
                    icon="arrow-circle-right"
                    disabled={smes.output_val === smes.output_level_max}
                    tooltip={
                      smes.output_val === smes.output_level_max
                        ? 'This output is already maxed.'
                        : ''
                    }
                    onClick={() =>
                      act('smes_out_max', { smes_out_max: smes.RCON_tag })
                    }
                  />
                  &nbsp;
                  {smes.output_set ? (
                    <Box color="green" as="span">
                      (ONLINE)
                    </Box>
                  ) : (
                    <Box color="red" as="span">
                      (OFFLINE)
                    </Box>
                  )}
                </LabeledList.Item>
              </LabeledList>
            </Section>
          ))}
      </Section>
    </Collapsible>
  );
};

export const BreakerInfo = (props, context) => {
  const { act, data } = useBackend<RCONData>(context);
  const [breakerSearchTerm, setBreakerSearchTerm] = useLocalState<string>(
    context,
    `breakerSearchTerm`,
    ``
  );

  return (
    <Collapsible open>
      <Section
        title="Breaker Control"
        buttons={
          <Input
            placeholder="Search by breaker name"
            width="40vw"
            maxLength={512}
            onInput={(e, value) => {
              setBreakerSearchTerm(value);
            }}
            value={breakerSearchTerm}
          />
        }>
        <LabeledList>
          {data.breaker_info
            .filter(
              (b) =>
                b.RCON_tag.toLowerCase().indexOf(
                  breakerSearchTerm.toLowerCase()
                ) > -1
            )
            .map((breaker) => (
              <LabeledList.Item label={breaker.RCON_tag} key={breaker.RCON_tag}>
                <Button
                  icon="power-off"
                  color={breaker.enabled ? 'green' : 'red'}
                  tooltip={breaker.enabled ? 'Enabled.' : 'Disabled.'}
                  onClick={() =>
                    act('toggle_breaker', { toggle_breaker: breaker.RCON_tag })
                  }
                />
              </LabeledList.Item>
            ))}
        </LabeledList>
      </Section>
    </Collapsible>
  );
};
