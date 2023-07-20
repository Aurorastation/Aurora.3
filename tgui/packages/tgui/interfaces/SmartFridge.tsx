import { BooleanLike } from '../../common/react';
import { useBackend, useLocalState } from '../backend';
import { BlockQuote, Box, Button, LabeledList, Section, Input } from '../components';
import { Window } from '../layouts';

export type FridgeData = {
  contents: Item[];
  seconds_electrified: BooleanLike;
  shoot_inventory: BooleanLike;
  locked: number; // goes to -1
  secure: BooleanLike;
};

type Item = {
  display_name: string;
  vend: number;
  quantity: number;
};

export const SmartFridge = (props, context) => {
  const { act, data } = useBackend<FridgeData>(context);
  const [searchTerm, setSearchTerm] = useLocalState<string>(
    context,
    `searchTerm`,
    ``
  );

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section
          title="Storage"
          buttons={
            <Input
              selfClear
              placeholder="Search..."
              onInput={(e, value) => {
                setSearchTerm(value);
              }}
              value={searchTerm}
            />
          }>
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

  return (
    <Section>
      <LabeledList>
        {data.contents
          .filter(
            (item) =>
              item.display_name
                .toLowerCase()
                .indexOf(searchTerm.toLowerCase()) > -1
          )
          .sort()
          .map((item) => (
            <LabeledList.Item key={item.display_name} label={item.display_name}>
              x{item.quantity}&nbsp;
              {item.quantity > 0 ? (
                <Button
                  content="x1"
                  icon="arrow-alt-circle-down"
                  onClick={() => {
                    act('vendItem', { vendItem: item.vend, amount: 1 });
                  }}
                />
              ) : (
                ''
              )}
              {item.quantity > 5 ? (
                <Button
                  content="x5"
                  icon="arrow-alt-circle-down"
                  onClick={() => {
                    act('vendItem', { vendItem: item.vend, amount: 5 });
                  }}
                />
              ) : (
                ''
              )}
              {item.quantity > 10 ? (
                <Button
                  content="x10"
                  icon="arrow-alt-circle-down"
                  onClick={() => {
                    act('vendItem', { vendItem: item.vend, amount: 10 });
                  }}
                />
              ) : (
                ''
              )}
              {item.quantity > 25 ? (
                <Button
                  content="x25"
                  icon="arrow-alt-circle-down"
                  onClick={() => {
                    act('vendItem', { vendItem: item.vend, amount: 25 });
                  }}
                />
              ) : (
                ''
              )}
            </LabeledList.Item>
          ))}
      </LabeledList>
    </Section>
  );
};
