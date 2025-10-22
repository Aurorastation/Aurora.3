import { Button, Collapsible, Input, Section } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';

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
            <Input
              autoFocus
              autoSelect
              placeholder="Search by name"
              width="40vw"
              maxLength={512}
              onChange={(value) => {
                setSearchTerm(value);
              }}
              value={searchTerm}
            />
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
