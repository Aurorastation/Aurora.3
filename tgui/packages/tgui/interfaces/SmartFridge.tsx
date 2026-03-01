import { BooleanLike } from '../../common/react';
import { useBackend, useLocalState } from '../backend';
import { BlockQuote, Box, Button, Section, Input } from '../components';
import { Window } from '../layouts';

export type FridgeData = {
  contents: Item[];
  seconds_electrified: BooleanLike;
  shoot_inventory: BooleanLike;
  locked: number; // goes to -1
  secure: BooleanLike;
  sort_alphabetically: BooleanLike;
};

type Item = {
  display_name: string;
  vend: number;
  quantity: number;
  icon?: string | null;
};

export const SmartFridge = (props, context) => {
  const { act, data } = useBackend<FridgeData>(context);
  const [searchTerm, setSearchTerm] = useLocalState<string>(
    context,
    `searchTerm`,
    ``,
  );

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section
          title="Storage"
          buttons={
            <Section>
              <Input
                selfClear
                placeholder="Search..."
                onInput={(e, value) => {
                  setSearchTerm(value);
                }}
                value={searchTerm}
              />
              <Button
                content="Sort"
                selected={data.sort_alphabetically}
                onClick={() => act('switch_sort_alphabetically')}
              />
            </Section>
          }
        >
          {data.secure ? (
            data.locked === -1 ? (
              <BlockQuote>
                <Box color="bad">
                  Sec.re ACC_** //:securi_ntdiag##or 1%($...
                </Box>
              </BlockQuote>
            ) : (
              <BlockQuote>
                <Box color="good">
                  Secure Access: Please have your identification ready.
                </Box>
              </BlockQuote>
            )
          ) : (
            ''
          )}
          {data.contents ? <ContentsWindow /> : 'No contents loaded.'}
        </Section>
      </Window.Content>
    </Window>
  );
};

export const ContentsWindow = (props, context) => {
  const { act, data } = useBackend<FridgeData>(context);
  const [searchTerm] = useLocalState<string>(context, `searchTerm`, ``);
  const itemList = data.contents.filter(
    (item) =>
      item.display_name.toLowerCase().indexOf(searchTerm.toLowerCase()) > -1,
  );
  const itemListSorted = data.sort_alphabetically
    ? itemList.sort((item1, item2) => {
        return item1.display_name.localeCompare(item2.display_name);
      })
    : itemList;

  return (
    <Section>
      <Box>
        {itemListSorted.map((item) => (
          <Box
            key={`${item.vend}-${item.display_name}`}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '8px',
              padding: '4px 0',
            }}
          >
            {/* Item icon */}
            {item.icon ? (
              <Box
                as="img"
                src={`data:image/png;base64,${item.icon}`}
                style={{ width: '32px', height: '32px', flexShrink: 0 }}
              />
            ) : null}
            {/* Name stuff */}
            <Box
              style={{
                flex: 2,
                minWidth: 0,
                whiteSpace: 'normal',
                overflowWrap: 'break-word',
                wordBreak: 'break-word',
              }}
            >
              {item.display_name}
            </Box>
            {/* Amount */}x{item.quantity}
            {/* Vend buttons */}
            <Box
              style={{
                flex: 1.2,
                minWidth: 0,
                whiteSpace: 'normal',
                overflowWrap: 'break-word',
                wordBreak: 'break-word',
              }}
            >
              {item.quantity > 0 && (
                <Button
                  content="x1"
                  icon="arrow-alt-circle-down"
                  width="50px"
                  onClick={() =>
                    act('vendItem', { vendItem: item.vend, amount: 1 })
                  }
                />
              )}
              {item.quantity > 5 && (
                <Button
                  content="x5"
                  icon="arrow-alt-circle-down"
                  width="50px"
                  onClick={() =>
                    act('vendItem', { vendItem: item.vend, amount: 5 })
                  }
                />
              )}
              {item.quantity > 10 && (
                <Button
                  content="x10"
                  icon="arrow-alt-circle-down"
                  width="50px"
                  onClick={() =>
                    act('vendItem', { vendItem: item.vend, amount: 10 })
                  }
                />
              )}
              {item.quantity > 25 && (
                <Button
                  content="x25"
                  icon="arrow-alt-circle-down"
                  width="50px"
                  onClick={() =>
                    act('vendItem', { vendItem: item.vend, amount: 25 })
                  }
                />
              )}
            </Box>
          </Box>
        ))}
      </Box>
    </Section>
  );
};
