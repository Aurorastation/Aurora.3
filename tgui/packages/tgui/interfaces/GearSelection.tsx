import { useState } from 'react';
import {
  Box,
  Button,
  Image,
  Input,
  Section,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { InputButtons } from './common/InputButtons';

type GearSelectionItem = {
  icon?: string;
  name: string;
};

type GearSelectionData = {
  default_item: string;
  items: GearSelectionItem[];
};

export const GearSelection = () => {
  const { act, data } = useBackend<GearSelectionData>();
  const { default_item, items = [] } = data;
  const [searchQuery, setSearchQuery] = useState('');
  const [selected, setSelected] = useState(default_item);

  const filteredItems = items.filter((item) =>
    item.name.toLowerCase().includes(searchQuery.toLowerCase()),
  );
  const selectedItem =
    filteredItems.find((item) => item.name === selected) ?? filteredItems[0];

  const submit = () => {
    if (selectedItem) {
      act('submit', { entry: selectedItem.name });
    }
  };

  return (
    <Window title="Choose Gear Type" width={420} height={500}>
      <Window.Content>
        <Section fill title="Choose a type">
          <Stack fill vertical>
            <Stack.Item>
              <Input
                autoFocus
                fluid
                onChange={setSearchQuery}
                onEnter={submit}
                placeholder="Search..."
                value={searchQuery}
              />
            </Stack.Item>
            <Stack.Item grow>
              <Section fill scrollable>
                {filteredItems.map((item) => (
                  <Button
                    className="candystripe"
                    color="transparent"
                    fluid
                    key={item.name}
                    onClick={() => setSelected(item.name)}
                    onDoubleClick={() => act('submit', { entry: item.name })}
                    selected={item.name === selectedItem?.name}
                    style={{
                      animation: 'none',
                      minHeight: '48px',
                      transition: 'none',
                    }}
                  >
                    <Stack align="center">
                      <Stack.Item width="48px">
                        {item.icon && (
                          <Image
                            height="40px"
                            src={`data:image/png;base64,${item.icon}`}
                            style={{ imageRendering: 'pixelated' }}
                            width="40px"
                          />
                        )}
                      </Stack.Item>
                      <Stack.Item grow>
                        {item.name.replace(/^\w/, (character) =>
                          character.toUpperCase(),
                        )}
                      </Stack.Item>
                    </Stack>
                  </Button>
                ))}
                {!filteredItems.length && (
                  <Box color="label" p={2} textAlign="center">
                    No matching gear types.
                  </Box>
                )}
              </Section>
            </Stack.Item>
            <Stack.Item>
              <InputButtons
                disabled={!selectedItem}
                input={selectedItem?.name ?? ''}
                on_cancel={() => act('cancel')}
                on_submit={submit}
              />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
