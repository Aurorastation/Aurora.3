import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Section } from '../components';
import { NtosWindow } from '../layouts';

export type LawData = {
  ion_law_nr: string;
  ion_law: string;
  zeroth_law: string;
  inherent_law: string;
  supplied_law: string;
  supplied_law_position: number;

  zeroth_laws: Law[];
  ion_laws: Law[];
  inherent_laws: Law[];
  supplied_laws: Law[];
  law_sets: Law[];

  isAI: BooleanLike;
  isMalf: BooleanLike;
  isSlaved: BooleanLike;
  isAdmin: BooleanLike;
  view: number;

  channel: string;
  channels: Channel[];
};

type Law = {
  law: string;
  index: number;
  state: string;
  ref: string;
};

type Channel = {
  channel: string;
};

export const LawManager = (props, context) => {
  const { act, data } = useBackend<LawData>(context);

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        <Section title="Title" />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
