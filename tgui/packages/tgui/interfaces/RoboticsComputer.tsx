import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, NoticeBox, Section } from '../components';
import { NtosWindow } from '../layouts';

export type RoboticsData = {
  diagnostic: BooleanLike;
};

export const RoboticsComputer = (props, context) => {
  const { act, data } = useBackend<RoboticsData>(context);

  return (
    <NtosWindow>
      <NtosWindow.Content scrollable>
        <Section
          title="Robotics Interface"
          button={
            <Button
              content="Run Diagnostics"
              onClick={() => act('run_diagnostics')}
            />
          }>
          {!data.diagnostic ? (
            <NoticeBox>
              You must run a diagnostics first to be able to access it.
            </NoticeBox>
          ) : (
            <NoticeBox>
              Access diagnostic:{' '}
              <Button icon="info" onClick={() => act('open_diagnostic')} />
            </NoticeBox>
          )}
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
