import { BooleanLike } from '../../common/react';
import { capitalizeAll } from '../../common/string';
import { useBackend } from '../backend';
import { Box, Button, LabeledControls, LabeledList, NoticeBox, Section } from '../components';
import { NtosWindow } from '../layouts';

export type MerchantData = {
  temp: string;
  mode: BooleanLike;
  last_comms: string;
  pad: BooleanLike;
  bank: number;

  traderName: string;
  origin: string;
  hailed: BooleanLike;
  trades: string[];
};

export const Merchant = (props, context) => {
  const { act, data } = useBackend<MerchantData>(context);

  return (
    <NtosWindow resizable width={900} height={600}>
      <NtosWindow.Content scrollable>
        {data.temp ? <TempWindow /> : data.mode ? <ModeWindow /> : <MainMenu />}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const ModeWindow = (props, context) => {
  const { act, data } = useBackend<MerchantData>(context);

  return (
    <Section
      title={'Orion Express Goods Trading' + ' (Balance: ' + data.bank + '电)'}
      buttons={
        <>
          <Button
            icon="arrow-left"
            onClick={() => act('PRG_scroll', { PRG_scroll: 'left' })}
          />
          <Button icon="home" onClick={() => act('PRG_main_menu')} />
          <Button
            icon="arrow-right"
            onClick={() => act('PRG_scroll', { PRG_scroll: 'right' })}
          />
        </>
      }>
      <Box fontSize={1.5} bold>
        {data.traderName}
      </Box>
      Signal Origin: {data.origin}
      {data.last_comms ? <Box italic>{data.last_comms}</Box> : ''}
      {data.hailed ? <Hailed /> : <NotHailed />}
    </Section>
  );
};

export const Hailed = (props, context) => {
  const { act, data } = useBackend<MerchantData>(context);

  return (
    <Section>
      {data.trades ? (
        <Section
          title="Communications"
          buttons={
            <Button icon="arrow-left" onClick={() => act('PRG_show_trades')} />
          }>
          {data.trades.map((trade) => (
            <Section key={trade}>
              <Box fontSize={1.5} textAlign="centre" bold>
                {capitalizeAll(trade)}
              </Box>
              <LabeledControls>
                <LabeledControls.Item>
                  <Button
                    content="Trade"
                    onClick={() =>
                      act('PRG_offer_item', {
                        PRG_offer_item: data.trades.indexOf(trade),
                      })
                    }
                  />
                </LabeledControls.Item>
                <LabeledControls.Item>
                  <Button
                    content="Money"
                    onClick={() =>
                      act('PRG_offer_money_for_item', {
                        PRG_offer_money_for_item: data.trades.indexOf(trade),
                      })
                    }
                  />
                </LabeledControls.Item>
                <LabeledControls.Item>
                  <Button
                    content="Ask Cost"
                    onClick={() =>
                      act('PRG_how_much_do_you_want', {
                        PRG_how_much_do_you_want: data.trades.indexOf(trade),
                      })
                    }
                  />
                </LabeledControls.Item>
                <LabeledControls.Item>
                  <Button
                    content="Bulk"
                    onClick={() =>
                      act('PRG_bulk_money_for_item', {
                        PRG_bulk_money_for_item: data.trades.indexOf(trade),
                      })
                    }
                  />
                </LabeledControls.Item>
              </LabeledControls>
            </Section>
          ))}
        </Section>
      ) : (
        <Section title="Communications">
          <LabeledControls>
            <LabeledControls.Item>
              <Button
                content="Show Goods"
                onClick={() => act('PRG_show_trades')}
              />
            </LabeledControls.Item>
            <LabeledControls.Item>
              <Button
                content="Sell Items"
                onClick={() => act('PRG_sell_items')}
              />
            </LabeledControls.Item>
            <LabeledControls.Item />
            <LabeledControls.Item>
              <Button
                content="Compliment"
                onClick={() => act('PRG_compliment')}
              />
            </LabeledControls.Item>
            <LabeledControls.Item>
              <Button content="Insult" onClick={() => act('PRG_insult')} />
            </LabeledControls.Item>
            <LabeledControls.Item>
              <Button
                content="Information"
                tooltip="This will give you information on what the merchant would want for a trade."
                onClick={() => act('PRG_what_do_you_want')}
              />
            </LabeledControls.Item>
          </LabeledControls>
          <LabeledList>
            <LabeledList.Item label="Bribe">
              <Button
                content="100电"
                tooltip="This will pay them an amount of credits to stay in the sector longer."
                onClick={() => act('PRG_bribe', { PRG_bribe: 100 })}
              />
              <Button
                content="500电"
                tooltip="This will pay them an amount of credits to stay in the sector longer."
                onClick={() => act('PRG_bribe', { PRG_bribe: 100 })}
              />
              <Button
                content="1000电"
                tooltip="This will pay them an amount of credits to stay in the sector longer."
                onClick={() => act('PRG_bribe', { PRG_bribe: 1000 })}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      )}
    </Section>
  );
};

export const NotHailed = (props, context) => {
  const { act, data } = useBackend<MerchantData>(context);

  return (
    <Section title="Communications">
      <Button content="Hail" onClick={() => act('PRG_hail')} />
    </Section>
  );
};

export const MainMenu = (props, context) => {
  const { act, data } = useBackend<MerchantData>(context);

  return (
    <Section
      title={
        'Orion Express Trade Interface' + ' (Balance: ' + data.bank + '电)'
      }>
      <LabeledControls>
        <LabeledControls.Item>
          <Button
            content="Open Communications"
            onClick={() => act('PRG_merchant_list')}
          />
        </LabeledControls.Item>
        <LabeledControls.Item>
          <Button
            content="Test Fire"
            tooltip="This will test fire your transponder."
            onClick={() => act('PRG_test_fire')}
          />
        </LabeledControls.Item>
        <LabeledControls.Item>
          <Button
            content="Connect Pad"
            onClick={() => act('PRG_connect_pad')}
          />
        </LabeledControls.Item>
        <LabeledControls.Item>
          <Button
            content="Deposit Credits"
            onClick={() => act('PRG_transfer_to_bank')}
          />
        </LabeledControls.Item>
        <LabeledControls.Item>
          <Button
            content="Retrieve Credits"
            onClick={() => act('PRG_get_money')}
          />
        </LabeledControls.Item>
      </LabeledControls>
      <LabeledList>
        <LabeledList.Item label="Pad Status">
          {data.pad ? 'Connected' : 'Not Connected'}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

export const TempWindow = (props, context) => {
  const { act, data } = useBackend<MerchantData>(context);

  return (
    <Section
      title="Orion Express Trade Services"
      buttons={
        <Button
          content="Continue"
          icon="play"
          onClick={() => act('PRG_continue')}
        />
      }>
      <NoticeBox>{data.temp}</NoticeBox>
    </Section>
  );
};
