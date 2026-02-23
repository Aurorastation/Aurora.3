import { useBackend } from '../../backend';
import { Button, LabeledList, Section } from '../../components';
import { CommunicatorData } from './types';

export const CommunicatorSettingsTab = (props, context) => {
  const { act, data } = useBackend<CommunicatorData>(context);
  const { userComm, ringerOn } = data;

  return (
    <Section title="Settings">
      <LabeledList>
        <LabeledList.Item label="Display Name">
          <Button.Input
            fluid
            content={userComm.username}
            currentValue={userComm.username}
            defaultValue="__reset" // this is weird but it works
            onCommit={(_, value) => act('set_username', { new_name: value })}
          />
        </LabeledList.Item>
        <LabeledList.Item label="NTNet Address">
          {userComm.address}
        </LabeledList.Item>
        <LabeledList.Item label="NTNet Visibility">
          <Button.Checkbox
            fluid
            checked={userComm.visible}
            selected={userComm.visible}
            onClick={() => act('toggle_visibility')}
          >
            {userComm.visible
              ? 'Visible to other devices'
              : 'Invisible to other devices'}
          </Button.Checkbox>
        </LabeledList.Item>
        <LabeledList.Item label="Camera Mode">
          <Button fluid>placeholder</Button>
        </LabeledList.Item>
        <LabeledList.Item label="Ringer">
          <Button.Checkbox
            fluid
            checked={ringerOn}
            selected={ringerOn}
            onClick={() => act('toggle_ringer')}
          >
            {ringerOn ? 'Ringer on' : 'Ringer off'}
          </Button.Checkbox>
          <Button fluid onClick={() => act('set_ringtone')}>
            Set ringtone
          </Button>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
