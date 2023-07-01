import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export type LateJoinData = {
  character_name: string;
  character_image: any; // base64 icon
  round_duration: string;
  alert_level: string;
  shuttle_status: string;
  unique_role_available: BooleanLike;
  jobs_available: number;
  jobs_list: Job[];
  departments: string[];
};

type Job = {
  title: string;
  department: string;
  head: BooleanLike;
  total_positions: number;
  current_positions: number;
};

export const LateJoin = (props, context) => {
  const { act, data } = useBackend<LateJoinData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section>
          <Section textAlign="center">
            Welcome, <Box bold>{data.character_name + '.'}</Box>
            {
              <Box
                as="img"
                m={0}
                src={`data:image/jpeg;base64,${data.character_image}`}
                width="35%"
                height="35%"
                style={{
                  '-ms-interpolation-mode': 'nearest-neighbor',
                }}
              />
            }
          </Section>
          <LabeledList>
            <LabeledList.Item label="Round Duration">
              {data.round_duration}
            </LabeledList.Item>
            <LabeledList.Item label="Alert Level">
              <Box as="span" color={alertLevelColor(data.alert_level)}>
                {data.alert_level}
              </Box>
            </LabeledList.Item>
            <LabeledList.Item label="Ghost Roles">
              <Button
                content="View Spawners"
                selected={data.unique_role_available}
                icon="star"
                tooltip={
                  data.unique_role_available &&
                  'There are unique roles available.'
                }
                onClick={() => act('ghostspawner', { ghostspawner: 1 })}
              />
            </LabeledList.Item>
          </LabeledList>
          {shuttleStatusMessage(data.shuttle_status) ? (
            <NoticeBox>{shuttleStatusMessage(data.shuttle_status)}</NoticeBox>
          ) : (
            ''
          )}
        </Section>
        {data.jobs_available > 0 ? <JobsList /> : 'No jobs available.'}
      </Window.Content>
    </Window>
  );
};

export const JobsList = (props, context) => {
  const { act, data } = useBackend<LateJoinData>(context);

  return (
    <Section textAlign="center">
      {data.departments.map((department) => (
        <Section
          title={department}
          key={department}
          className={'border-dept-' + department.toLowerCase()}>
          {data.jobs_list
            .filter((job) => job.department === department)
            .map((job) => (
              <Button
                key={job.title}
                content={
                  job.total_positions !== -1
                    ? job.title +
                    ' (' +
                    job.current_positions +
                    ' / ' +
                    job.total_positions +
                    ')'
                    : job.title
                }
                bold={job.head}
                width="100%"
                onClick={() => act('SelectedJob', { SelectedJob: job.title })}
              />
            ))}
        </Section>
      ))}
    </Section>
  );
};
const shuttleStatusMessage = (shuttle_status) => {
  switch (shuttle_status) {
    case 'post-evac':
      return 'The ship has been evacuated.';
    case 'evac':
      return 'The ship is currently undergoing evacuation procedures.';
    case 'transfer':
      return 'The ship is currently undergoing crew transfer procedures.';
  }
  return null;
};

const alertLevelColor = (alert_level) => {
  switch (alert_level.toLowerCase()) {
    case 'green':
      return 'green';
    case 'blue':
      return 'blue';
    case 'yellow':
      return 'yellow';
  }
  return 'red';
};
