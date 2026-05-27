import {
  Button,
  Divider,
  Dropdown,
  Input,
  LabeledList,
  NumberInput,
  Section,
} from 'tgui-core/components';
import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';

export type NarrateData = {
  narrate_styles: string[];
  narrate_locations: string[];
  narrate_filters: string[];
};

export const NarratePanel = (props) => {
  const { act, data } = useBackend<NarrateData>();
  const [narrateText, setNarrateText] = useLocalState('narrateText', '');
  const [narrateSize, setNarrateSize] = useLocalState('narrateSize', 2);
  const [narrateRange, setNarrateRange] = useLocalState('narrateRange', 7);
  const [narrateStyle, setNarrateStyle] = useLocalState('textStyle', 'notice');
  const [narrateLocation, setNarrateLocation] = useLocalState(
    'narrateLocation',
    'View',
  );
  const [narrateFilter, setNarrateFilter] = useLocalState(
    'narrateFilter',
    'None',
  );

  return (
    <Window theme="admin" width={600} height={300}>
      <Window.Content scrollable>
        <Section
          title="Narrate Panel"
          buttons={
            <Button
              content="Narrate"
              disabled={!narrateText.length}
              color="good"
              icon="star"
              onClick={() =>
                act('narrate', {
                  narrate_text: narrateText,
                  narrate_size: narrateSize,
                  narrate_range: narrateRange,
                  narrate_style: narrateStyle,
                  narrate_location: narrateLocation,
                  narrate_filter: narrateFilter,
                })
              }
            />
          }
        >
          <Input
            fluid
            strict
            placeholder="Input your narration here..."
            onInput={(value) => setNarrateText(value)}
            selfClear
            autoFocus
            autoSelect
          />
          <Divider />
          <LabeledList>
            <LabeledList.Item label="Narrate Size">
              <NumberInput
                value={narrateSize}
                minValue={1}
                maxValue={6}
                unit="px"
                step={1}
                stepPixelSize={10}
                onDrag={(value) => setNarrateSize(value)}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Narrate Range">
              <NumberInput
                value={narrateRange}
                minValue={1}
                maxValue={14}
                unit="tiles"
                step={1}
                stepPixelSize={3}
                onDrag={(value) => setNarrateRange(value)}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Style">
              <Dropdown
                options={data.narrate_styles}
                displayText={narrateStyle}
                width="50%"
                onSelected={(value) => setNarrateStyle(value)}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Location">
              <Dropdown
                options={data.narrate_locations}
                selected={data.narrate_locations[1]}
                displayText={narrateLocation}
                width="50%"
                onSelected={(value) => setNarrateLocation(value)}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Filter">
              <Dropdown
                options={data.narrate_filters}
                selected={data.narrate_filters[1]}
                displayText={narrateFilter}
                width="50%"
                onSelected={(value) => setNarrateFilter(value)}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
