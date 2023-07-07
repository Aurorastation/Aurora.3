import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { BlockQuote, Button, LabeledList, Section } from '../components';
import { NtosWindow, Window } from '../layouts';

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
}

export const Merchant = (props, context) => {
  const { act, data } = useBackend<MerchantData>(context);

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        <Section title="Orion Express Trade Services" buttons={<Button content="Continue" icon="play" onClick={() => act('PRG_continue')} />}>
          <BlockQuote>{data.temp}</BlockQuote>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
