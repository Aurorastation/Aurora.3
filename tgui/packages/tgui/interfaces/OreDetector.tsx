import { useBackend } from '../backend';
import { Button, Section, LabeledList } from '../components';
import { Window } from '../layouts';
import { BooleanLike } from '../../common/react';

export type ScannerData = {
  enabled: BooleanLike;
  search_ores: string[];
  ore_names: string[];
};

export const OreDetector = (props, context) => {
  const { act, data } = useBackend<ScannerData>(context);

  const ore_enabled = (ore_name) => {
    if (!data.search_ores) {
      return false;
    }
    return data.search_ores.includes(ore_name);
  };

  const get_status = () => {
    if (data.search_ores.length === 0) {
      return 'CANT ENABLE - SELECT ORES';
    }
    if (data.enabled) {
      return 'ENALBED';
    } else {
      return 'DISABLED';
    }
  };

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Ore Detector">
          <LabeledList>
            <LabeledList.Item
              label="Status"
              buttons={
                <Button
                  icon="power-off"
                  disabled={!data.search_ores.length}
                  onClick={() => act('toggle')}
                />
              }>
              {get_status()}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Selected Ores">
          <LabeledList>
            {data.ore_names.map((ore) => (
              <LabeledList.Item
                key={ore}
                label={ore}
                buttons={
                  <Button onClick={() => act('select_ore', { ore_name: ore })}>
                    Toggle
                  </Button>
                }>
                {ore_enabled(ore) ? 'ENABLED' : 'DISABLED'}
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
