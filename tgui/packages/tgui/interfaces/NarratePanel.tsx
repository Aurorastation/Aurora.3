import { useBackend, useLocalState } from '../backend';
import { Button, Divider, Input, LabeledList, NumberInput, Section } from '../components';
import { Dropdown } from '../components/Dropdown';
import { Window } from '../layouts';

export type NarrateData = {
  narrate_styles: string[];
  narrate_locations: string[];
};

export const NarratePanel = (props, context) => {
  const { act, data } = useBackend<NarrateData>(context);
  const [narrateText, setNarrateText] = useLocalState(
    context,
    'narrateText',
    ''
  );
  const [narrateSize, setNarrateSize] = useLocalState(
    context,
    'narrateSize',
    2
  );
  const [narrateRange, setNarrateRange] = useLocalState(
    context,
    'narrateRange',
    7
  );
  const [narrateStyle, setNarrateStyle] = useLocalState(
    context,
    'textStyle',
    'notice'
  );
  const [narrateLocation, setNarrateLocation] = useLocalState(
    context,
    'narrateLocation',
    'View'
  );

  return (
    <Window resizable theme="admin" width={600} height={300}>
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
                })
              }
            />
          }>
          <Input
            fluid
            strict
            placeholder="Input your narration here..."
            onInput={(e, value) => setNarrateText(value)}
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
                onDrag={(e, value) => setNarrateSize(value)}
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
                onDrag={(e, value) => setNarrateRange(value)}
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
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
