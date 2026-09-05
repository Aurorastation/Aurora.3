import { Box, Button, LabeledList, Section } from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
  selected_job: string | null;
  selected_alt_title: string | null;
  selected_faction: string | null;
  selected_insertion: string | null;
  selected_announce: boolean;
};

export const IntruderTeleporter = (props) => {
  const { act, data } = useBackend<Data>();

  const canDeploy =
    data.selected_job &&
    data.selected_alt_title &&
    data.selected_faction &&
    data.selected_insertion;

  return (
    <Window theme="syndicate" width={500} height={400} title="Infiltration Deployment Terminal">
      <Window.Content scrollable>
        <Section title="INTRUDER DEPLOYMENT TERMINAL" fill textAlign="center">
          <LabeledList>
            <LabeledList.Item label="Job">
              <Button content={data.selected_job || 'Select'} onClick={() => act('select_job')} />
            </LabeledList.Item>
            <LabeledList.Item label="Title">
              <Button
                content={data.selected_alt_title || 'Select'}
                disabled={!data.selected_job}
                onClick={() => act('select_alt_title')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Company">
              <Button
                content={data.selected_faction || 'Select'}
                disabled={!data.selected_alt_title}
                onClick={() => act('select_faction')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Deployment method">
              <Button
                content={data.selected_insertion || 'Select'}
                disabled={!data.selected_job}
                onClick={() => act('select_insertion')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Arrival announcement">
              <Button
                content={data.selected_announce ? 'Announce arrival' : 'Silent arrival'}
                disabled={data.selected_insertion !== 'Residential Lift'}
                onClick={() => act('select_announce')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Deploy">
              <Button
                content="Deploy"
                disabled={!canDeploy}
                onClick={() => act('deploy')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
