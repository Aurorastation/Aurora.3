import { useBackend } from '../backend';
import { Box, Divider, Section } from '../components';
import { Window } from '../layouts';

export type FlavorTextData = {
  flavor_text: string;
};

// Credits to https://www.js-craft.io/blog/react-detect-url-text-convert-link
// for this Linkify code
const Linkify = ({ text }) => {
  const isUrl = (word) => {
    const urlPattern =
      /^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/gm;
    return word.match(urlPattern);
  };

  const addMarkup = (word) => {
    return isUrl(word) ? `<a href="${word}">${word}</a>` : word;
  };

  const words = text.split(' ');
  const formatedWords = words.map((w, i) => addMarkup(w));
  const html = formatedWords.join(' ');
  return <Box key={text} dangerouslySetInnerHTML={{ __html: html }} />;
};

export const FlavorText = (props, context) => {
  const { act, data } = useBackend<FlavorTextData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section>
          {data.flavor_text.split('\n').map((line) =>
            line ? (
              <Box>
                <Linkify text={line} />
                <Divider />
              </Box>
            ) : null
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
