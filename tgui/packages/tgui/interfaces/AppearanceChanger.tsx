import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { capitalize } from '../../common/string';
import { Button, Collapsible, NumberInput, Section } from '../components';
import { Window } from '../layouts';

export type ChangerData = {
  owner_species: string;
  change_race: BooleanLike;
  valid_species: string[];
  owner_speech_bubble: string;
  valid_speech_bubbles: string[];
  height_max: number;
  height_min: number;
  owner_height: number;

  owner_gender: string;
  owner_pronouns: string;
  change_gender: BooleanLike;
  valid_genders: string[];
  valid_pronouns: string[];

  change_culture: BooleanLike;
  owner_culture: string;
  valid_cultures: string[];
  owner_origin: string;
  valid_origins: string[];
  owner_citizenship: string;
  valid_citizenships: string[];
  owner_accent: string;
  valid_accents: string[];

  owner_languages: string[];
  change_language: BooleanLike;
  valid_languages: string[];

  change_skin_tone: BooleanLike;
  change_skin_color: BooleanLike;
  change_skin_preset: BooleanLike;
  change_eye_color: BooleanLike;

  change_hair: BooleanLike;
  owner_hair_style: string;
  valid_hair_styles: string[];

  change_facial_hair: BooleanLike;
  owner_facial_hair_style: string;
  valid_facial_hair_styles: string[];

  change_hair_color: BooleanLike;
  change_facial_hair_color: BooleanLike;
};

export const AppearanceChanger = (props, context) => {
  const { act, data } = useBackend<ChangerData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        {data.change_race ? <SpeciesWindow /> : ''}
        {data.change_gender ? <GenderWindow /> : ''}
        {data.change_culture ? <CultureWindow /> : ''}
        {data.change_language ? <LanguagesWindow /> : ''}
        <ColorsWindow />
        {data.change_hair && data.valid_hair_styles.length ? (
          <HairWindow />
        ) : (
          ''
        )}
      </Window.Content>
    </Window>
  );
};

export const SpeciesWindow = (props, context) => {
  const { act, data } = useBackend<ChangerData>(context);

  return (
    <Section title="Species">
      <Collapsible content="Species">
        {data.valid_species.map((species) => (
          <Button
            key={species}
            content={species}
            selected={data.owner_species === species}
            onClick={() => act('race', { race: species })}
          />
        ))}
      </Collapsible>
      <Section title="Speech Bubble Type">
        {data.valid_speech_bubbles.length
          ? data.valid_speech_bubbles.map((new_speech_bubble) => (
            <Button
              key={new_speech_bubble}
              content={capitalize(new_speech_bubble)}
              selected={data.owner_speech_bubble === new_speech_bubble}
              onClick={() =>
                act('speech_bubble', { speech_bubble: new_speech_bubble })
              }
            />
          ))
          : ''}
      </Section>
      <Section title="Height">
        <NumberInput
          value={data.owner_height}
          maxValue={data.height_max}
          minValue={data.height_min}
          unit="cm"
          onDrag={(e, value) => act('set_height', { height: value })}
        />
      </Section>
    </Section>
  );
};

export const GenderWindow = (props, context) => {
  const { act, data } = useBackend<ChangerData>(context);

  return (
    <Section title="Gender and Pronouns">
      {data.valid_genders.map((new_gender) => (
        <Button
          key={new_gender}
          content={capitalize(new_gender)}
          selected={data.owner_gender === new_gender}
          onClick={() => act('gender', { gender: new_gender })}
        />
      ))}
      <Section title="Pronouns">
        {data.valid_pronouns.map((pronoun) => (
          <Button
            key={pronoun}
            content={capitalize(pronoun)}
            selected={data.owner_pronouns === pronoun}
            onClick={() => act('pronoun', { pronouns: pronoun })}
          />
        ))}
      </Section>
    </Section>
  );
};

export const CultureWindow = (props, context) => {
  const { act, data } = useBackend<ChangerData>(context);

  return (
    <Section title="Cultures">
      {data.valid_cultures.map((new_culture) => (
        <Button
          key={new_culture}
          content={new_culture}
          selected={data.owner_culture === new_culture}
          onClick={() => act('culture', { culture: new_culture })}
        />
      ))}
      <Section title="Origins">
        {data.valid_origins.map((new_origin) => (
          <Button
            key={new_origin}
            content={new_origin}
            selected={data.owner_origin === new_origin}
            onClick={() => act('origin', { origin: new_origin })}
          />
        ))}
      </Section>
      <Section title="Citizenships">
        {data.valid_citizenships.map((new_citizenship) => (
          <Button
            key={new_citizenship}
            content={new_citizenship}
            selected={data.owner_citizenship === new_citizenship}
            onClick={() => act('citizenship', { citizenship: new_citizenship })}
          />
        ))}
      </Section>
      <Section title="Accents">
        {data.valid_accents.map((new_accent) => (
          <Button
            key={new_accent}
            content={new_accent}
            selected={data.owner_accent === new_accent}
            onClick={() => act('accent', { accent: new_accent })}
          />
        ))}
      </Section>
    </Section>
  );
};

export const LanguagesWindow = (props, context) => {
  const { act, data } = useBackend<ChangerData>(context);

  return (
    <Section title="Languages">
      {data.valid_languages.map((new_language) => (
        <Button
          key={new_language}
          content={new_language}
          selected={data.owner_languages.includes(new_language)}
          onClick={() => act('language', { language: new_language })}
        />
      ))}
    </Section>
  );
};

export const ColorsWindow = (props, context) => {
  const { act, data } = useBackend<ChangerData>(context);

  return (
    <Section title="Colors">
      {data.change_eye_color ? (
        <Button content="Eye Color" onClick={() => act('eye_color')} />
      ) : (
        ''
      )}
      {data.change_skin_tone ? (
        <Button content="Skin Tone" onClick={() => act('skin_tone')} />
      ) : (
        ''
      )}
      {data.change_skin_preset ? (
        <Button content="Skin Preset" onClick={() => act('skin_preset')} />
      ) : (
        ''
      )}
      {data.change_skin_color ? (
        <Button content="Skin Color" onClick={() => act('skin_color')} />
      ) : (
        ''
      )}
      {data.change_hair_color ? (
        <Button content="Hair Color" onClick={() => act('hair_color')} />
      ) : (
        ''
      )}
      {data.change_facial_hair_color ? (
        <Button
          content="Facial Hair Color"
          onClick={() => act('facial_hair_color')}
        />
      ) : (
        ''
      )}
    </Section>
  );
};

export const HairWindow = (props, context) => {
  const { act, data } = useBackend<ChangerData>(context);

  return (
    <Section title="Hair Styles">
      <Collapsible content="Hair Styles">
        {data.valid_hair_styles.map((new_hair_style) => (
          <Button
            key={new_hair_style}
            content={new_hair_style}
            selected={data.owner_hair_style === new_hair_style}
            onClick={() => act('hair', { hair: new_hair_style })}
          />
        ))}
      </Collapsible>
      {data.change_facial_hair && data.valid_facial_hair_styles.length && (
        <Collapsible content="Facial Hair Styles">
          {data.valid_facial_hair_styles.map((new_facial_hair_style) => (
            <Button
              key={new_facial_hair_style}
              content={new_facial_hair_style}
              selected={data.owner_facial_hair_style === new_facial_hair_style}
              onClick={() =>
                act('facial_hair', { facial_hair: new_facial_hair_style })
              }
            />
          ))}
        </Collapsible>
      )}
    </Section>
  );
};
