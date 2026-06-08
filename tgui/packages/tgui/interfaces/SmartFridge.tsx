import {
  BlockQuote,
  Box,
  Button,
  Image,
  Section,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';
import { SearchBar } from './common/SearchBar';

export type FridgeData = {
  contents: Item[];
  stocks: { [display_name: string]: number };
  seconds_electrified: BooleanLike;
  shoot_inventory: BooleanLike;
  locked: number; // goes to -1
  secure: BooleanLike;
  sort_alphabetically: BooleanLike;
};

type Item = {
  display_name: string;
  vend: number;
  icon?: string | null;
};

export const SmartFridge = (props) => {
  const { act, data } = useBackend<FridgeData>();
  const [searchTerm, setSearchTerm] = useLocalState<string>(`searchTerm`, ``);

  return (
    <Window>
      <Window.Content scrollable>
        <Section
          title="Storage"
          buttons={
            <SearchBar
              placeholder="Search..."
              query={searchTerm}
              onSearch={(value) => {
                setSearchTerm(value);
              }}
              style={{ width: '16rem' }}
            />
          }
        >
          {data.secure ? (
            data.locked === -1 ? (
              <BlockQuote>
                <Box color="bad">
                  {/** biome-ignore lint/suspicious/noCommentText: Just flavor text */}
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

export const ContentsWindow = (props) => {
  const { act, data } = useBackend<FridgeData>();
  const [searchTerm] = useLocalState<string>(`searchTerm`, ``);
  const itemList = data.contents.filter(
    (item) =>
      item.display_name.toLowerCase().indexOf(searchTerm.toLowerCase()) > -1,
  );
  const itemListSorted = data.sort_alphabetically
    ? itemList.sort((item1, item2) => {
        return item1.display_name.localeCompare(item2.display_name);
      })
    : itemList;

  const itemStock = (item: Item) => data.stocks[item.display_name] || 0;

  return (
    <Section>
      <Box>
        {itemListSorted.map((item) => {
          const quantity = itemStock(item);
          return (
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
                <Image
                  width="32px"
                  height="32px"
                  src={`data:image/png;base64,${item.icon}`}
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
              {/* Amount */}x{quantity}
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
                {quantity > 0 && (
                  <Button
                    content="x1"
                    icon="arrow-alt-circle-down"
                    width="50px"
                    onClick={() =>
                      act('vendItem', { vendItem: item.vend, amount: 1 })
                    }
                  />
                )}
                {quantity > 5 && (
                  <Button
                    content="x5"
                    icon="arrow-alt-circle-down"
                    width="50px"
                    onClick={() =>
                      act('vendItem', { vendItem: item.vend, amount: 5 })
                    }
                  />
                )}
                {quantity > 10 && (
                  <Button
                    content="x10"
                    icon="arrow-alt-circle-down"
                    width="50px"
                    onClick={() =>
                      act('vendItem', { vendItem: item.vend, amount: 10 })
                    }
                  />
                )}
                {quantity > 25 && (
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
          );
        })}
      </Box>
    </Section>
  );
};
