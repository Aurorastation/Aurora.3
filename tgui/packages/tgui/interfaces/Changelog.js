import { classes } from 'common/react';
import dateformat from 'dateformat';
import yaml from 'js-yaml';
import { Component, Fragment } from 'inferno';

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { Box, Button, Dropdown, Icon, Section, Stack, Table } from '../components';
import { Window } from '../layouts';

const icons = {
  add: { icon: 'check-circle', color: 'green' },
  admin: { icon: 'user-shield', color: 'purple' },
  balance: { icon: 'balance-scale-right', color: 'yellow' },
  bugfix: { icon: 'bug', color: 'green' },
  code_imp: { icon: 'code', color: 'green' },
  config: { icon: 'cogs', color: 'purple' },
  expansion: { icon: 'check-circle', color: 'green' },
  experiment: { icon: 'radiation', color: 'yellow' },
  image: { icon: 'image', color: 'green' },
  imageadd: { icon: 'tg-image-plus', color: 'green' },
  imagedel: { icon: 'tg-image-minus', color: 'red' },
  qol: { icon: 'hand-holding-heart', color: 'green' },
  refactor: { icon: 'tools', color: 'green' },
  rscadd: { icon: 'check-circle', color: 'green' },
  rscdel: { icon: 'times-circle', color: 'red' },
  server: { icon: 'server', color: 'purple' },
  sound: { icon: 'volume-high', color: 'green' },
  soundadd: { icon: 'tg-sound-plus', color: 'green' },
  sounddel: { icon: 'tg-sound-minus', color: 'red' },
  spellcheck: { icon: 'spell-check', color: 'green' },
  tgs: { icon: 'toolbox', color: 'purple' },
  tweak: { icon: 'wrench', color: 'green' },
  unknown: { icon: 'info-circle', color: 'label' },
  wip: { icon: 'hammer', color: 'orange' },
};

export class Changelog extends Component {
  constructor(props) {
    super(props);
    this.state = {
      data: 'Loading changelog data...',
      selectedDate: '',
      selectedIndex: 0,
    };
    this.dateChoices = [];
  }

  setData(data) {
    this.setState({ data });
  }

  setSelectedDate(selectedDate) {
    this.setState({ selectedDate });
  }

  setSelectedIndex(selectedIndex) {
    this.setState({ selectedIndex });
  }

  getData = (date, attemptNumber = 1) => {
    const { act } = useBackend(this.context);
    const self = this;
    const maxAttempts = 6;

    if (attemptNumber > maxAttempts) {
      return this.setData(
        'Failed to load data after ' + maxAttempts + ' attempts'
      );
    }

    act('get_month', { date });

    fetch(resolveAsset(date + '.yml')).then(async (changelogData) => {
      const result = await changelogData.text();
      const errorRegex = /^Cannot find/;

      if (errorRegex.test(result)) {
        const timeout = 50 + attemptNumber * 50;

        self.setData('Loading changelog data' + '.'.repeat(attemptNumber + 3));
        setTimeout(() => {
          self.getData(date, attemptNumber + 1);
        }, timeout);
      } else {
        self.setData(yaml.load(result, { schema: yaml.CORE_SCHEMA }));
      }
    });
  };

  componentDidMount() {
    const {
      data: { dates = [] },
    } = useBackend(this.context);

    if (dates) {
      dates.forEach((date) =>
        this.dateChoices.push(dateformat(date, 'mmmm yyyy', true))
      );
      this.setSelectedDate(this.dateChoices[0]);
      this.getData(dates[0]);
    }
  }

  render() {
    const { data, selectedDate, selectedIndex } = this.state;
    const {
      data: { dates },
    } = useBackend(this.context);
    const { dateChoices } = this;

    const dateDropdown = dateChoices.length > 0 && (
      <Stack mb={1}>
        <Stack.Item>
          <Button
            className="Changelog__Button"
            disabled={selectedIndex === 0}
            icon={'chevron-left'}
            onClick={() => {
              const index = selectedIndex - 1;

              this.setData('Loading changelog data...');
              this.setSelectedIndex(index);
              this.setSelectedDate(dateChoices[index]);
              window.scrollTo(
                0,
                document.body.scrollHeight ||
                  document.documentElement.scrollHeight
              );
              return this.getData(dates[index]);
            }}
          />
        </Stack.Item>
        <Stack.Item>
          <Dropdown
            displayText={selectedDate}
            options={dateChoices}
            onSelected={(value) => {
              const index = dateChoices.indexOf(value);

              this.setData('Loading changelog data...');
              this.setSelectedIndex(index);
              this.setSelectedDate(value);
              window.scrollTo(
                0,
                document.body.scrollHeight ||
                  document.documentElement.scrollHeight
              );
              return this.getData(dates[index]);
            }}
            selected={selectedDate}
            width={'150px'}
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            className="Changelog__Button"
            disabled={selectedIndex === dateChoices.length - 1}
            icon={'chevron-right'}
            onClick={() => {
              const index = selectedIndex + 1;

              this.setData('Loading changelog data...');
              this.setSelectedIndex(index);
              this.setSelectedDate(dateChoices[index]);
              window.scrollTo(
                0,
                document.body.scrollHeight ||
                  document.documentElement.scrollHeight
              );
              return this.getData(dates[index]);
            }}
          />
        </Stack.Item>
      </Stack>
    );

    const header = (
      <Section>
        <h1>AuroraStation, a Space Station 13 game</h1>
        <p>
          <b>Thanks to: </b>
          Baystation 12, tgstation, /vg/station, NTstation, CDK Station devs,
          FacepunchStation, GoonStation devs, the original Space Station 13
          developers, Invisty for the title image and the countless others who
          have contributed to the game, issue tracker or wiki over the years.
        </p>
        <p>
          {'Current organization members can be found '}
          <a href="https://forums.aurorastation.org/staff/">here</a>
          {', recent GitHub contributors can be found '}
          <a href="https://github.com/Aurorastation/Aurora.3/pulse/monthly">
            here
          </a>
          .
        </p>
        <p>
          {'You can also join our discord '}
          <a href="https://discord.gg/0sYA49zHYGnKWM9p">here</a>.
        </p>
        {dateDropdown}
      </Section>
    );

    const footer = (
      <Section>
        {dateDropdown}
        <h3>AuroraStation Development Team</h3>
        <p>
          <b>Coders: </b>
          Arrow768, MattAtlas, Alberyk, FluffyGhost, Geeves, Dreamykass,
          Wildkins, Gem
        </p>
        <p>
          <b>Spriters: </b>
          WowzewoW, nauticall
        </p>
        <p>
          AuroraStation is thankful to all the contributors that contributed
          over the years.
        </p>
        <p>
          {'Except where otherwise noted, AuroraStation art is licensed under '}
          <a href="https://creativecommons.org/licenses/by-nc-sa/3.0/">
            Creative Commons Attribution-Noncommercial-Share Alike 3.0 License
          </a>
        </p>
        <h3>AuroraStation License</h3>
        <p>
          {' Our code is licensed under '}
          <a href="https://www.gnu.org/licenses/agpl-3.0.html">GNU AGPL v3</a>
        </p>
        <p>
          The TGS DMAPI API is licensed as a subproject under the MIT license.
          {' See the footer of '}
          <a
            href={
              'https://github.com/tgstation/tgstation/blob/master' +
              '/code/__DEFINES/tgs.dm'
            }>
            code/__DEFINES/tgs.dm
          </a>
          {' and '}
          <a
            href={
              'https://github.com/tgstation/tgstation/blob/master' +
              '/code/modules/tgs/LICENSE'
            }>
            code/modules/tgs/LICENSE
          </a>
          {' for the MIT license.'}
        </p>
        <p>
          {'All assets including icons and sound are under a '}
          <a href="https://creativecommons.org/licenses/by-sa/3.0/">
            Creative Commons 3.0 BY-SA license
          </a>
          {' unless otherwise indicated.'}
        </p>
      </Section>
    );

    const changes =
      typeof data === 'object' &&
      Object.keys(data).length > 0 &&
      Object.entries(data)
        .reverse()
        .map(([date, authors]) => (
          <Section key={date} title={dateformat(date, 'd mmmm yyyy', true)}>
            <Box ml={3}>
              {Object.entries(authors).map(([name, changes]) => (
                <Fragment key={name}>
                  <h4>{name} changed:</h4>
                  <Box ml={3}>
                    <Table>
                      {changes.map((change) => {
                        const changeType = Object.keys(change)[0];
                        return (
                          <Table.Row key={changeType + change[changeType]}>
                            <Table.Cell
                              className={classes([
                                'Changelog__Cell',
                                'Changelog__Cell--Icon',
                              ])}>
                              <Icon
                                color={
                                  icons[changeType]
                                    ? icons[changeType].color
                                    : icons['unknown'].color
                                }
                                name={
                                  icons[changeType]
                                    ? icons[changeType].icon
                                    : icons['unknown'].icon
                                }
                              />
                            </Table.Cell>
                            <Table.Cell className="Changelog__Cell">
                              {change[changeType]}
                            </Table.Cell>
                          </Table.Row>
                        );
                      })}
                    </Table>
                  </Box>
                </Fragment>
              ))}
            </Box>
          </Section>
        ));

    return (
      <Window title="Changelog" width={675} height={650}>
        <Window.Content scrollable>
          {header}
          {changes}
          {typeof data === 'string' && <p>{data}</p>}
          {footer}
        </Window.Content>
      </Window>
    );
  }
}
