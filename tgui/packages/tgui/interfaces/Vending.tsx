import {
  Box,
  Button,
  Flex,
  Input,
  LabeledList,
  NoticeBox,
  Section,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { capitalizeAll } from 'tgui-core/string';
import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';

export type VendingData = {
  vending_item: BooleanLike;
  sel_key: number;
  sel_name: string;
  sel_price: number;
  sel_icon: string;
  message: string;
  message_err: string;
  display_ad: string;

  products: Product[];
  coin: string;

  speaker: BooleanLike;
  panel: BooleanLike;
  manufacturer: string;

  width_override: number;
  height_override: number;
};

type Product = {
  key: string;
  name: string;
  price: number;
  amount: number;
  icon_tag: string;
};

export const Vending = (props) => {
  const { act, data } = useBackend<VendingData>();

  return (
    <Window width={425} height={500} theme={data.manufacturer}>
      <Window.Content scrollable>
        <Box textAlign="center">{data.display_ad}</Box>
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

export const ShowAllItems = (props) => {
  const { act, data } = useBackend<VendingData>();
  const [searchTerm, setSearchTerm] = useLocalState<string>(`searchTerm`, ``);

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
              onChange={(value) => {
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
        {data.products
          .filter(
            (product) =>
              product.name.toLowerCase().indexOf(searchTerm.toLowerCase()) > -1,
          )
          ?.map((product) => (
            <Button
              tooltip={product.name}
              key={product.name}
              disabled={data.vending_item || product.amount <= 0}
              onClick={() => act('vendItem', { vendItem: product.key })}
              style={{
                height: '70px',
                width: '70px',
              }}
            >
              <Box
                as="img"
                className={product.icon_tag}
                style={{
                  transform: 'scale(1.5) translate(30%, 30%)',
                }}
              />
              <Flex>
                <Flex.Item py={2}>
                  <Box as="span" fontSize="10px">
                    ({product.amount}x)
                  </Box>
                </Flex.Item>
                <Flex.Item py={2} px={2}>
                  {product.price ? (
                    <Box as="span" fontSize="10px">
                      {product.price.toFixed(2)}电
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

export const ShowVendingItem = (props) => {
  const { act, data } = useBackend<VendingData>();

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
      }
    >
      <LabeledList>
        <LabeledList.Item label="Selected Item">
          {capitalizeAll(data.sel_name)}
        </LabeledList.Item>
        <LabeledList.Item label="Price">
          {data.sel_price.toFixed(2)}电
        </LabeledList.Item>
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
