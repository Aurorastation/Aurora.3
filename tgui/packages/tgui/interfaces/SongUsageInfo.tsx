import { LabeledList, ProgressBar, Section } from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type SongUsageInfoData = {
  channels_left: number;
  events_active: number;
  max_channels: number;
  max_events: number;
};

export const SongUsageInfo = (props) => {
  const { data } = useBackend<SongUsageInfoData>();

  return (
    <Window title="Usage Info" width={400} height={160} theme="ntos">
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Channels Used">
              <ProgressBar
                value={data.max_channels - data.channels_left}
                minValue={0}
                maxValue={data.max_channels}
                color={
                  data.channels_left > data.max_channels * 0.2 ? 'good' : 'bad'
                }
              >
                {data.max_channels - data.channels_left} / {data.max_channels}
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Active Events">
              <ProgressBar
                value={data.events_active}
                minValue={0}
                maxValue={data.max_events}
                color={
                  data.events_active < data.max_events * 0.8 ? 'good' : 'bad'
                }
              >
                {data.events_active} / {data.max_events}
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
