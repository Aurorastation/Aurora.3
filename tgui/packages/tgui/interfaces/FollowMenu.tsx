import { Button, Collapsible, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';
import { SearchBar } from './common/SearchBar';

export type FollowData = {
  ghosts: Ghost[];
  categories: string[];
  is_mod: BooleanLike;
};

type Ghost = {
  name: string;
  ref: string;
  category: string;
  special_character: number; // 0 (non-antag), 1 (special role) or 2 (antag)
};

export const FollowMenu = (props) => {
  const { act, data } = useBackend<FollowData>();
  const [searchTerm, setSearchTerm] = useLocalState<string>(`searchTerm`, ``);

  return (
    <Window>
      <Window.Content scrollable>
        <Section
          title="Follow Menu"
          buttons={
            <Stack align="center">
              <Stack.Item>
                <SearchBar
                  autoFocus
                  placeholder="Search by name"
                  query={searchTerm}
                  onSearch={(value) => {
                    setSearchTerm(value);
                  }}
                  style={{ width: '18rem' }}
                />
              </Stack.Item>
              <Stack.Item>
                <Button content="Refresh" onClick={() => act('refresh')} />
              </Stack.Item>
            </Stack>
          }
        >
          {data.categories.sort().map((category) => (
            <Section title="" key={category}>
              <Collapsible open={true} title={category}>
                {data.ghosts?.length &&
                  data.ghosts
                    .filter(
                      (ghost) =>
                        ghost.name
                          .toLowerCase()
                          .indexOf(searchTerm.toLowerCase()) > -1 &&
                        category === ghost.category,
                    )
                    .map((ghost) => (
                      <Button
                        key={ghost.name}
                        content={ghost.name}
                        color={
                          data.is_mod
                            ? ghost.special_character > 0
                              ? 'bad'
                              : ''
                            : ''
                        }
                        onClick={() =>
                          act('follow_target', { follow_target: ghost.ref })
                        }
                      />
                    ))}
              </Collapsible>
            </Section>
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
