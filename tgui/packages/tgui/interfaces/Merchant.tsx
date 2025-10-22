import {
  Box,
  Button,
  LabeledControls,
  LabeledList,
  NoticeBox,
  Section,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { capitalizeAll } from 'tgui-core/string';
import { useBackend } from '../backend';
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

export const Merchant = (props) => {
  const { act, data } = useBackend<MerchantData>();

  return (
    <NtosWindow width={900} height={600}>
      <NtosWindow.Content scrollable>
        {data.temp ? <TempWindow /> : data.mode ? <ModeWindow /> : <MainMenu />}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const ModeWindow = (props) => {
  const { act, data } = useBackend<MerchantData>();

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
      }
    >
      <Box fontSize={1.5} bold>
        {data.traderName}
      </Box>
      Signal Origin: {data.origin}
      {data.last_comms ? <Box italic>{data.last_comms}</Box> : ''}
      {data.hailed ? <Hailed /> : <NotHailed />}
    </Section>
  );
};

export const Hailed = (props) => {
  const { act, data } = useBackend<MerchantData>();

  return (
    <Section>
      {data.trades ? (
        <Section
          title="Communications"
          buttons={
            <Button icon="arrow-left" onClick={() => act('PRG_show_trades')} />
          }
        >
          {data.trades.map((trade) => (
            <Section key={trade}>
              <Box fontSize={1.5} textAlign="centre" bold>
                {capitalizeAll(trade)}
              </Box>
              <LabeledControls>
                <LabeledControls.Item label="Trade">
                  <Button
                    onClick={() =>
                      act('PRG_offer_item', {
                        PRG_offer_item: data.trades.indexOf(trade),
                      })
                    }
                  />
                </LabeledControls.Item>
                <LabeledControls.Item label="Money">
                  <Button
                    onClick={() =>
                      act('PRG_offer_money_for_item', {
                        PRG_offer_money_for_item: data.trades.indexOf(trade),
                      })
                    }
                  />
                </LabeledControls.Item>
                <LabeledControls.Item label="Ask Cost">
                  <Button
                    onClick={() =>
                      act('PRG_how_much_do_you_want', {
                        PRG_how_much_do_you_want: data.trades.indexOf(trade),
                      })
                    }
                  />
                </LabeledControls.Item>
                <LabeledControls.Item label="Bulk">
                  <Button
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
            <LabeledControls.Item label="Show Goods">
              <Button onClick={() => act('PRG_show_trades')} />
            </LabeledControls.Item>
            <LabeledControls.Item label="Sell Items">
              <Button onClick={() => act('PRG_sell_items')} />
            </LabeledControls.Item>
            <LabeledControls.Item label="" />
            <LabeledControls.Item label="Compliment">
              <Button onClick={() => act('PRG_compliment')} />
            </LabeledControls.Item>
            <LabeledControls.Item label="Insult">
              <Button onClick={() => act('PRG_insult')} />
            </LabeledControls.Item>
            <LabeledControls.Item label="Information">
              <Button
                tooltip="This will give you information on what the merchant would want for a trade."
                onClick={() => act('PRG_what_do_you_want')}
              />
            </LabeledControls.Item>
          </LabeledControls>
          <LabeledList>
            <LabeledList.Item label="Bribe">
              <Button
                tooltip="This will pay them an amount of credits to stay in the sector longer."
                onClick={() => act('PRG_bribe', { PRG_bribe: 100 })}
              >
                "100电"
              </Button>
              <Button
                tooltip="This will pay them an amount of credits to stay in the sector longer."
                onClick={() => act('PRG_bribe', { PRG_bribe: 100 })}
              >
                "500电"
              </Button>
              <Button
                tooltip="This will pay them an amount of credits to stay in the sector longer."
                onClick={() => act('PRG_bribe', { PRG_bribe: 1000 })}
              >
                "1000电"
              </Button>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      )}
    </Section>
  );
};

export const NotHailed = (props) => {
  const { act, data } = useBackend<MerchantData>();

  return (
    <Section title="Communications">
      <Button content="Hail" onClick={() => act('PRG_hail')} />
    </Section>
  );
};

export const MainMenu = (props) => {
  const { act, data } = useBackend<MerchantData>();

  return (
    <Section
      title={
        'Orion Express Trade Interface' + ' (Balance: ' + data.bank + '电)'
      }
    >
      <LabeledControls>
        <LabeledControls.Item label="Open Communications">
          <Button onClick={() => act('PRG_merchant_list')} />
        </LabeledControls.Item>
        <LabeledControls.Item label="Test Fire">
          <Button
            tooltip="This will test fire your transponder."
            onClick={() => act('PRG_test_fire')}
          />
        </LabeledControls.Item>
        <LabeledControls.Item label="Connect Pad">
          <Button onClick={() => act('PRG_connect_pad')} />
        </LabeledControls.Item>
        <LabeledControls.Item label="Deposit Credits">
          <Button onClick={() => act('PRG_transfer_to_bank')} />
        </LabeledControls.Item>
        <LabeledControls.Item label="Retrieve Credits">
          <Button onClick={() => act('PRG_get_money')} />
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

export const TempWindow = (props) => {
  const { act, data } = useBackend<MerchantData>();

  return (
    <Section
      title="Orion Express Trade Services"
      buttons={
        <Button
          content="Continue"
          icon="play"
          onClick={() => act('PRG_continue')}
        />
      }
    >
      <NoticeBox>{data.temp}</NoticeBox>
    </Section>
  );
};
