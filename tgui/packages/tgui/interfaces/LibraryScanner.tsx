import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Box, Button, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export type LibraryScannerData = {
  has_book: BooleanLike;
  book_title: string | null;
  book_author: string | null;
  is_anchored: BooleanLike;
};

export const LibraryScanner = (props, context) => {
  const { act, data } = useBackend<LibraryScannerData>(context);

  if (!data.is_anchored) {
    return (
      <Window title="Book Scanner" width={400} height={150}>
        <Window.Content>
          <NoticeBox danger>
            The scanner must be secured to the floor first.
          </NoticeBox>
        </Window.Content>
      </Window>
    );
  }

  return (
    <Window title="Book Scanner" width={400} height={250}>
      <Window.Content>
        <Section title="Memory Status">
          {data.has_book ? (
            <>
              <Box color="good">Data stored in memory.</Box>
              <Box mt={1}>
                <Box inline bold>
                  Title:
                </Box>{' '}
                {data.book_title}
              </Box>
              <Box>
                <Box inline bold>
                  Author:
                </Box>{' '}
                {data.book_author || 'Anonymous'}
              </Box>
            </>
          ) : (
            <Box color="average">No data stored in memory.</Box>
          )}
        </Section>
        <Section title="Controls">
          <Button icon="barcode" content="Scan" onClick={() => act('scan')} />
          {!!data.has_book && (
            <>
              <Button
                icon="times"
                content="Clear Memory"
                onClick={() => act('clear')}
              />
              <Button
                icon="eject"
                content="Remove Book"
                onClick={() => act('eject')}
              />
            </>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
