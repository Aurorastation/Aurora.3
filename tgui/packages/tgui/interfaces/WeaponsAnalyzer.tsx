import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { capitalizeAll } from '../../common/string';
import { BlockQuote, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export type AnalyzerData = {
  laser_assembly: LaserAssembly;
  gun: Gun;
  item: Item;
  gun_mods: GunMod[];
};

type LaserAssembly = {
  name: string;
};

type GunMod = {
  name: string;
  reliability: number;
  damage_modifier: number;
  fire_delay_modifier: number;
  shots_modifier: number;
  burst_modifier: number;
  accuracy_modifier: number;
  repair_tool: string;
};

type Gun = {
  name: string;
  max_shots: number;
  burst: number;
  reliability: number;
  recharge: string;
  recharge_time: number;
  damage: number;
  damage_type: string;
  stun: string;
  shrapnel_type: string;
  armor_penetration: number;
  secondary_damage: number;
  secondary_damage_type: string;
  secondary_check_armor: string;
  secondary_stun: string;
  secondary_shrapnel_type: string;
  secondary_armor_penetration: number;
};

type Item = {
  name: string;
  force: number;
  sharp: string;
  edge: string;
  penetration: number;
  throw_force: string;
  damage_type: string;
  energy: BooleanLike;
  active_force: number;
  active_throw_force: number;
  can_block: string;
  base_reflect_chance: number;
  base_block_chance: number;
  shield_power: number;
};

export const WeaponsAnalyzer = (props, context) => {
  const { act, data } = useBackend<AnalyzerData>(context);

  return (
    <Window resizable theme="zavodskoi">
      <Window.Content scrollable>
        {data.item ? (
          <ItemWindow />
        ) : data.laser_assembly ? (
          <AssemblyWindow />
        ) : data.gun ? (
          <GunWindow />
        ) : (
          <BlockQuote>No item inserted.</BlockQuote>
        )}
      </Window.Content>
    </Window>
  );
};

export const ItemWindow = (props, context) => {
  const { act, data } = useBackend<AnalyzerData>(context);

  return (
    <Section title={data.item.name}>
      <LabeledList>
        <LabeledList.Item label="Damage Type">
          {data.item.damage_type}
        </LabeledList.Item>
        <LabeledList.Item label="Force Rating">
          {data.item.force} points
        </LabeledList.Item>
        <LabeledList.Item label="Throw Force Rating">
          {data.item.throw_force} points
        </LabeledList.Item>
        {data.item.energy ? (
          <>
            <LabeledList.Item label="Active Force Rating">
              {data.item.active_force} points
            </LabeledList.Item>
            <LabeledList.Item label="Active Throw Force Rating">
              {data.item.active_throw_force} points
            </LabeledList.Item>
            <LabeledList.Item label="Base Block Chance">
              {data.item.base_block_chance}%
            </LabeledList.Item>
            <LabeledList.Item label="Base Reflect Chance">
              {data.item.base_reflect_chance}%
            </LabeledList.Item>
            <LabeledList.Item label="Shield Rating">
              {data.item.shield_power} points
            </LabeledList.Item>
            <LabeledList.Item label="Block Bullets">
              {data.item.can_block}
            </LabeledList.Item>
          </>
        ) : (
          <>
            <LabeledList.Item label="Sharp">{data.item.sharp}</LabeledList.Item>
            <LabeledList.Item label="Dismembering">
              {data.item.edge}
            </LabeledList.Item>
            <LabeledList.Item label="Armor Penetration Rating">
              {data.item.penetration} points
            </LabeledList.Item>
          </>
        )}
      </LabeledList>
      <Button
        content="Print Analysis"
        icon="paper"
        onClick={() => act('print')}
      />
    </Section>
  );
};

export const GunWindow = (props, context) => {
  const { act, data } = useBackend<AnalyzerData>(context);

  return (
    <>
      <Section title={capitalizeAll(data.gun.name)}>
        <LabeledList>
          <LabeledList.Item label="Maximum Shots">
            {data.gun.max_shots} shots
          </LabeledList.Item>
          <LabeledList.Item label="Burst">
            {data.gun.burst} shots
          </LabeledList.Item>
          <LabeledList.Item label="Self Recharge">
            {capitalizeAll(data.gun.recharge)}
          </LabeledList.Item>
          <LabeledList.Item label="Reliability">
            {data.gun.reliability}
          </LabeledList.Item>
        </LabeledList>
        <Section title="First Projectile">
          <LabeledList>
            <LabeledList.Item label="Damage Rating">
              {data.gun.damage} points
            </LabeledList.Item>
            <LabeledList.Item label="Damage Type">
              {capitalizeAll(data.gun.damage_type)}
            </LabeledList.Item>
            <LabeledList.Item label="Armor Penetration Rating">
              {data.gun.armor_penetration} points
            </LabeledList.Item>
            <LabeledList.Item label="Shrapnel Type">
              {capitalizeAll(data.gun.shrapnel_type)}
            </LabeledList.Item>
            <LabeledList.Item label="Stun">
              {capitalizeAll(data.gun.stun)}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        {data.gun.secondary_damage ? (
          <Section title="Second Projectile">
            <LabeledList>
              <LabeledList.Item label="Damage Rating">
                {data.gun.secondary_damage} points
              </LabeledList.Item>
              <LabeledList.Item label="Damage Type">
                {capitalizeAll(data.gun.secondary_damage_type)}
              </LabeledList.Item>
              <LabeledList.Item label="Armor Penetration Rating">
                {data.gun.secondary_armor_penetration} points
              </LabeledList.Item>
              <LabeledList.Item label="Shrapnel Type">
                {capitalizeAll(data.gun.secondary_shrapnel_type)}
              </LabeledList.Item>
              <LabeledList.Item label="Stun">
                {capitalizeAll(data.gun.secondary_stun)}
              </LabeledList.Item>
            </LabeledList>
          </Section>
        ) : (
          ''
        )}
      </Section>
      {data.gun_mods ? <GunMods /> : 'No gun modifications detected.'}
      {!data.gun_mods ? (
        <Button
          content="Print Analysis"
          icon="paper"
          onClick={() => act('print')}
        />
      ) : (
        ''
      )}
    </>
  );
};

export const GunMods = (props, context) => {
  const { act, data } = useBackend<AnalyzerData>(context);

  return (
    <Section title="Modifications">
      {data.gun_mods ? (
        <>
          {data.gun_mods.map((mod) => (
            <Section key={mod.name} title={capitalizeAll(mod.name)}>
              <LabeledList>
                <LabeledList.Item label="Reliability">
                  {mod.reliability}
                </LabeledList.Item>
                <LabeledList.Item label="Damage Modifier">
                  {mod.damage_modifier}
                </LabeledList.Item>
                <LabeledList.Item label="Fire Delay Modifier">
                  {mod.fire_delay_modifier}
                </LabeledList.Item>
                <LabeledList.Item label="Shots Modifier">
                  {mod.shots_modifier}
                </LabeledList.Item>
                <LabeledList.Item label="Burst Modifier">
                  {mod.burst_modifier}
                </LabeledList.Item>
                <LabeledList.Item label="Accuracy Modifier">
                  {mod.accuracy_modifier}
                </LabeledList.Item>
                <LabeledList.Item label="Repair Tool">
                  {capitalizeAll(mod.repair_tool)}
                </LabeledList.Item>
              </LabeledList>
            </Section>
          ))}
          <Button
            content="Print Analysis"
            icon="calendar"
            onClick={() => act('print')}
          />
        </>
      ) : (
        'No modifications detected.'
      )}
    </Section>
  );
};

export const AssemblyWindow = (props, context) => {
  const { act, data } = useBackend<AnalyzerData>(context);

  return (
    <>
      <Section title={capitalizeAll(data.laser_assembly.name)} />
      <GunMods />
    </>
  );
};
