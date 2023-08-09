import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Box, Button, Divider, LabeledList, ProgressBar, Section } from '../components';
import { NtosWindow } from '../layouts';
import { sanitizeText } from '../sanitize';

export type NewsData = {
  message: string;

  title: string;
  article: string;

  download_running: BooleanLike;
  download_progress: number;
  download_maxprogress: number;
  download_rate: number;

  all_articles: Article[];
  showing_archived: BooleanLike;
};

type Article = {
  name: string;
  size: number;
  uid: number;
  archived: BooleanLike;
};

export const NTOSNewsBrowser = (props, context) => {
  const { act, data } = useBackend<NewsData>(context);

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        {data.message ? (
          <ErrorMessage />
        ) : data.article ? (
          <ShowArticle />
        ) : (
          <ShowArticleList />
        )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const ErrorMessage = (props, context) => {
  const { act, data } = useBackend<NewsData>(context);

  return (
    <Section
      title="Error"
      buttons={<Button content="Reset" onClick={() => act('PRG_reset')} />}>
      {data.message}
    </Section>
  );
};

export const ShowArticle = (props, context) => {
  const { act, data } = useBackend<NewsData>(context);
  const contentHtml = { __html: sanitizeText(data.article) };

  return (
    <Section
      title={data.title}
      buttons={
        <>
          <Button content="Save" onClick={() => act('PRG_savearticle')} />
          <Button content="Close" onClick={() => act('PRG_reset')} />
        </>
      }>
      <Box dangerouslySetInnerHtml={contentHtml} />
    </Section>
  );
};

export const ShowArticleList = (props, context) => {
  const { act, data } = useBackend<NewsData>(context);

  return (
    <Section
      title="Available Articles"
      buttons={
        <Button
          content={
            (data.showing_archived ? 'Hide' : 'Show') + ' Archived Files'
          }
          onClick={() => act('PRG_toggle_archived')}
        />
      }>
      {data.download_running && (
        <Section title="Download">
          <LabeledList>
            <LabeledList.Item label="Progress">
              <ProgressBar
                value={data.download_progress}
                minValue={0}
                maxValue={data.download_maxprogress}>
                {data.download_progress} / {data.download_maxprogress} GQ
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Download Speed">
              {data.download_rate} GQ/s
            </LabeledList.Item>
            <LabeledList.Item label="Abort">
              <Button
                icon="times"
                color="red"
                onClick={() => act('PRG_reset')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      )}
      {data.all_articles.length &&
        data.all_articles.map((article) => (
          <Box key={article.uid}>
            <LabeledList>
              <LabeledList.Item label="Name">{article.name}</LabeledList.Item>
              <LabeledList.Item label="Size">
                {article.size} GQ
              </LabeledList.Item>
              <LabeledList.Item label="Actions">
                <Button
                  content="Open"
                  onClick={() =>
                    act('PRG_openarticle', { PRG_openarticle: article.uid })
                  }
                />
              </LabeledList.Item>
            </LabeledList>
            <Divider />
          </Box>
        ))}
    </Section>
  );
};
