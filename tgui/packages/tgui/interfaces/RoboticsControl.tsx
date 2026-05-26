import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';

type RoboticsControlData = {
  robots: RobotEntry[];
  safety: BooleanLike;
  is_ai: BooleanLike;
};

type RobotEntry = {
  name: string;
  status: string;
  cell: BooleanLike;
  cell_capacity: number;
  cell_current: number;
  cell_percentage: number;
  module: string;
  master_ai: string;
  hackable: BooleanLike;
  hacked: BooleanLike;
  access: BooleanLike;
};

export const RoboticsControl = (props, context) => {
  const { act, data } = useBackend<RoboticsControlData>(context);

  return (
    <Window
      title="Robotic Control Console"
      width={440}
      height={520}
      theme="ntos"
    >
      <Window.Content scrollable>
        {!data.is_ai && (
          <Section title="Emergency Self-Destruct">
            <Button
              content={data.safety ? 'Safety: Armed' : 'Safety: DISABLED'}
              color={data.safety ? 'good' : 'bad'}
              onClick={() => act('arm')}
            />
            <Button
              ml={1}
              content="Detonate All"
              color="bad"
              disabled={!!data.safety}
              onClick={() => act('nuke')}
            />
          </Section>
        )}
        {data.robots.length === 0 ? (
          <NoticeBox>No cyborgs detected.</NoticeBox>
        ) : (
          data.robots.map((robot) => (
            <Section
              key={robot.name}
              title={robot.name}
              buttons={
                <Box
                  color={
                    robot.status === 'Operational'
                      ? 'good'
                      : robot.status === 'Lockdown'
                        ? 'average'
                        : 'bad'
                  }
                >
                  {robot.status}
                </Box>
              }
            >
              <LabeledList>
                <LabeledList.Item label="Module">
                  {robot.module}
                </LabeledList.Item>
                <LabeledList.Item label="Master AI">
                  {robot.master_ai}
                </LabeledList.Item>
                {!!robot.cell && (
                  <LabeledList.Item label="Power Cell">
                    <ProgressBar
                      value={robot.cell_current}
                      minValue={0}
                      maxValue={robot.cell_capacity}
                      color={
                        robot.cell_percentage > 50
                          ? 'good'
                          : robot.cell_percentage > 20
                            ? 'average'
                            : 'bad'
                      }
                    >
                      {robot.cell_percentage}%
                    </ProgressBar>
                  </LabeledList.Item>
                )}
                {!robot.cell && (
                  <LabeledList.Item label="Power Cell">
                    <Box color="bad">No Cell</Box>
                  </LabeledList.Item>
                )}
                <LabeledList.Item label="Controls">
                  <Button
                    content={
                      robot.status === 'Lockdown' ? 'Release' : 'Lockdown'
                    }
                    color={robot.status === 'Lockdown' ? 'good' : 'average'}
                    onClick={() => act('lockdown', { name: robot.name })}
                  />
                  {!data.is_ai && (
                    <Button
                      ml={1}
                      content={robot.access ? 'All Access' : 'Role Access'}
                      color={robot.access ? 'good' : 'default'}
                      onClick={() => act('access', { name: robot.name })}
                    />
                  )}
                  {!data.is_ai && (
                    <Button
                      ml={1}
                      content="Detonate"
                      color="bad"
                      onClick={() => act('detonate', { name: robot.name })}
                    />
                  )}
                  {!!robot.hackable && (
                    <Button
                      ml={1}
                      content="Hack"
                      color="bad"
                      onClick={() => act('hack', { name: robot.name })}
                    />
                  )}
                </LabeledList.Item>
              </LabeledList>
            </Section>
          ))
        )}
      </Window.Content>
    </Window>
  );
};
