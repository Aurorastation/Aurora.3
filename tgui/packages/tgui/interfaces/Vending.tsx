import { BooleanLike } from '../../common/react';
import { capitalizeAll } from '../../common/string';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Flex, Input, LabeledList, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export type VendingData = {
  vending_item: BooleanLike;
  sel_key: number;
  sel_name: string;
  sel_price: number;
  sel_icon: string;
  message: string;
  message_err: string;
  all_products_free: boolean;
  onstation: boolean;
  department: string;
  jobDiscount: number;
  displayed_currency_icon: string;
  displayed_currency_name: string;

  stock: StockItem[];
  coin: string;

  speaker: BooleanLike;
  manufacturer: string;

  width_override: number;
  height_override: number;
};

type UserData = {
  name: string;
  cash: number;
  job: string;
  department: string;
};

type StockItem = {
  key: string;
  name: string;
  price: number;
  amount: number;
  icon_tag: string;
};

export const Vending = (props, context) => {
  const { act, data } = useBackend<VendingData>(context);

  return (
    <Window resizable width={425} height={500} theme={data.manufacturer}>
      <Window.Content scrollable>
        <Section>
          {data.vending_item && data.sel_price !== 0 ? (
            <ShowVendingItem />
          ) : (
            <ShowAllItems />
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};

export const ShowAllItems = (props, context) => {
  const { act, data } = useBackend<VendingData>(context);
  const [searchTerm, setSearchTerm] = useLocalState<string>(
    context,
    `searchTerm`,
    ``
  );

  return (
    <>
      <Section
        title="Selection"
        buttons={
          <>
            <Input
              autoFocus
              autoSelect
              placeholder="Search by name"
              width="40vw"
              maxLength={512}
              onInput={(e, value) => {
                setSearchTerm(value);
              }}
              value={searchTerm}
            />
            {data.coin ? (
              <Button
                icon="coins"
                onClick={() => act('remove_coin')}
                tooltip={capitalizeAll(data.coin)}
              />
            ) : (
              ''
            )}
          </>
        }
      />
      <Section fill>
        {data.stock
          .filter(
            (StockItem) =>
              StockItem.name.toLowerCase().indexOf(searchTerm.toLowerCase()) >
              -1
          )
          ?.map((StockItem) => (
            <Button
              tooltip={StockItem.name}
              key={StockItem.name}
              disabled={data.vending_item || StockItem.amount <= 0}
              onClick={() => act('vendItem', { vendItem: StockItem.key })}
              style={{
                height: '70px',
                width: '70px',
              }}>
              <Box
                as="img"
                className={StockItem.icon_tag}
                style={{
                  '-ms-interpolation-mode': 'nearest-neighbor',
                  transform: 'scale(1.5) translate(30%, 30%)',
                }}
              />
              <Flex>
                <Flex.Item py={2}>
                  <Box as="span" fontSize="10px">
                    ({StockItem.amount}x)
                  </Box>
                </Flex.Item>
                <Flex.Item py={2} px={2}>
                  {StockItem.price ? (
                    <Box as="span" fontSize="10px">
                      {StockItem.price}电
                    </Box>
                  ) : (
                    ''
                  )}
                </Flex.Item>
              </Flex>
            </Button>
          ))}
      </Section>
    </>
  );
};

export const ShowVendingItem = (props, context) => {
  const { act, data } = useBackend<VendingData>(context);

  return (
    <Section
      title="Shopping Cart"
      buttons={
        <Button
          content="Cancel"
          icon="times"
          color="bad"
          onClick={() => act('cancelpurchase')}
        />
      }>
      <LabeledList>
        <LabeledList.Item label="Selected Item">
          {capitalizeAll(data.sel_name)}
        </LabeledList.Item>
        <LabeledList.Item label="Price">{data.sel_price}电</LabeledList.Item>
      </LabeledList>
      Please swipe your SCC ID to pay. &nbsp;
      {data.message_err ? (
        <NoticeBox color="bad">{data.message_err}</NoticeBox>
      ) : (
        ''
      )}
    </Section>
  );
};
