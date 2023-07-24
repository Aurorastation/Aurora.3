import { BooleanLike } from 'common/react';
import { useBackend, useLocalState } from '../backend';
import { BlockQuote, Box, Button, Dropdown, LabeledList, NoticeBox, Section, Tabs } from '../components';
import { NtosWindow } from '../layouts';

type NTOSClientData = {
  enrollment: number;
  available_presets: { [name: string]: string };
  ntnet_status: BooleanLike;
};

const DeviceEnrollment = (props, context) => {
  const { act, data } = useBackend<NTOSClientData>(context);
  const { available_presets, ntnet_status } = data;
  const [deviceType, setDeviceType] = useLocalState(
    context,
    'setDeviceType',
    1
  );
  const [devicePreset, setDevicePreset] = useLocalState(
    context,
    'setDevicePreset',
    ''
  );
  if (!ntnet_status) {
    return (
      <Section title="Device Enrollment">
        <NoticeBox warning>
          NTNet download servers are currently unavailable. Enrollment is not
          possible at this time.
        </NoticeBox>
      </Section>
    );
  } else {
    return (
      <Section title="Device Enrollment">
        <Tabs>
          <Tabs.Tab
            selected={deviceType === 1}
            onClick={() => setDeviceType(1)}>
            Company Device
          </Tabs.Tab>
          <Tabs.Tab
            selected={deviceType === 2}
            onClick={() => setDeviceType(2)}>
            Private Device
          </Tabs.Tab>
        </Tabs>
        <LabeledList>
          <LabeledList.Item label="Device Preset">
            <Dropdown
              options={Object.keys(available_presets)}
              selected={devicePreset}
              disabled={!(deviceType === 1)}
              displayText={deviceType === 1 ? null : 'Default'}
              onSelected={(value) => setDevicePreset(value)}
              width="100%"
            />
          </LabeledList.Item>
          {!(devicePreset === '' || deviceType === 2) && (
            <LabeledList.Item>
              <BlockQuote>{available_presets[devicePreset]}</BlockQuote>
            </LabeledList.Item>
          )}
          <LabeledList.Item label="Enroll Device">
            <Button
              disabled={
                deviceType === 0 || (deviceType === 1 && devicePreset === '')
              }
              onClick={() =>
                act('enroll', {
                  'enroll_type': deviceType,
                  'enroll_preset': devicePreset,
                })
              }>
              Confirm
            </Button>
          </LabeledList.Item>
        </LabeledList>
      </Section>
    );
  }
};

export const NTOSClientManager = (props, context) => {
  const { act, data } = useBackend<NTOSClientData>(context);
  const { enrollment } = data;
  return (
    <NtosWindow>
      <NtosWindow.Content scrollable>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Enrollment Status">
              {!enrollment ? (
                <Box as="span" color="red">
                  Unconfigured
                </Box>
              ) : enrollment === 1 ? (
                <Box as="span" color="label">
                  Work Device
                </Box>
              ) : (
                <Box as="span" color="label">
                  Private Device
                </Box>
              )}
            </LabeledList.Item>
            {enrollment === 1 && (
              <>
                <LabeledList.Item label="Policy Compliance Status">
                  Active
                </LabeledList.Item>
                <LabeledList.Item label="Remote Management Status">
                  Active
                </LabeledList.Item>
              </>
            )}
          </LabeledList>
        </Section>
        {enrollment === 0 && <DeviceEnrollment />}
      </NtosWindow.Content>
    </NtosWindow>
  );
};
