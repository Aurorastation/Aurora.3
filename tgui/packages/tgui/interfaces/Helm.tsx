import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, Section, Table } from '../components';
import { NtosWindow } from '../layouts';

export type HelmData = {
  sector: string;
  sector_info: string;
  landed: string;
  s_x: number;
  s_y: number;
  dest: BooleanLike;
  d_x: number;
  d_y: number;
  speedlimit: string;
  accel: number;
  heading: number;
  autopilot: BooleanLike;
  manual_control: BooleanLike;
  canburn: BooleanLike;
  cancombatroll: BooleanLike;
  cancombatturn: BooleanLike;
  accellimit: number;
  speed: number;
  ETAnext: number;
  //locations:;
};

export const Helm = (props, context) => {
  const { act, data } = useBackend<HelmData>(context);

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        <Section title="Helm Control">
          <Section title="Flight Data">
            <div style="">
              <fieldset style="min-height:180px;background-color: #202020;">
                <legend style="text-align:center">Flight data</legend>
                <div class="item">
                  <div class="itemLabelWider">ETA to next grid:</div>
                  <div style="float:right">{data.ETAnext}</div>
                </div>
                <div class="item">
                  <div class="itemLabelWider">Speed:</div>
                  <div style="float:right">{data.speed} Gm/h</div>
                </div>
                <div class="item">
                  <div class="itemLabelWider">Acceleration:</div>
                  <div style="float:right">{data.accel} Gm/h</div>
                </div>
                <div class="item">
                  <div class="itemLabelWider">Heading:</div>
                  <div style="float:right">{data.heading}&deg;</div>
                </div>
                <div class="item">
                  <div class="itemLabelWider">Acceleration limiter:</div>
                  <div style="float:right">
                    {/* {helper.link(data.accellimit, null, { 'accellimit' : 1}, null, null)}} Gm/h */}
                  </div>
                </div>
              </fieldset>
            </div>
          </Section>
          <Section title="Manual control">
            <div style="">
              <fieldset style="min-height:180px;background-color: #202020;">
                <legend style="text-align:center">Manual control</legend>
                <div class="item">
                  <div class="item">
                    <Button
                      icon="circle"
                      onClick={() => act('move', { move: 9 })}
                    />
                    <Button
                      icon="arrow-up"
                      onClick={() => act('move', { move: 1 })}
                    />
                    <Button
                      icon="circle"
                      onClick={() => act('move', { move: 5 })}
                    />
                  </div>
                  <div class="item">
                    {/* {{:helper.link('', 'triangle-1-w', { 'move' : 8 }, data.canburn ? null : 'disabled', null)}}
			{{:helper.link('', 'circle-close', { 'brake' : 1 }, data.canburn ? null : 'disabled', null)}}
			{{:helper.link('', 'triangle-1-e', { 'move' : 4 }, data.canburn ? null : 'disabled', null)}} */}
                    <Button
                      // disabled={!data.canburn}
                      icon="arrow-left"
                      onClick={() => act('move', { move: 8 })}
                    />
                    <Button
                      icon="bacon"
                      onClick={() => act('brake', { move: 1 })}
                    />
                    <Button
                      icon="arrow-right"
                      onClick={() => act('move', { move: 4 })}
                    />
                  </div>
                  <div class="item">
                    <Button
                      icon="circle"
                      onClick={() => act('move', { move: 10 })}
                    />
                    <Button
                      icon="arrow-down"
                      onClick={() => act('move', { move: 2 })}
                    />
                    <Button
                      icon="circle"
                      onClick={() => act('move', { move: 6 })}
                    />
                  </div>
                  <div class="item">
                    <div class="itemLabel">Maneuvers</div>
                    <br />
                    <div class="itemContent">
                      {/* {{:helper.link('', 'arrowstop-1-w', {'turn' : 8}, data.cancombatturn ? null : 'disabled', null)}}
				{{:helper.link('', 'arrowstop-1-e', {'turn' : 4}, data.cancombatturn ? null : 'disabled', null)}} */}
                    </div>
                    <div class="itemContent">
                      {/* {{:helper.link('', 'arrowreturnthick-1-w', {'roll' : 8}, data.cancombatroll ? null : 'disabled', null)}}
				{{:helper.link('', 'arrowreturnthick-1-e', {'roll' : 4}, data.cancombatroll ? null : 'disabled', null)}} */}
                    </div>
                  </div>

                  <div class="item">
                    <span class="white">Direct control</span>
                    <br />
                    {/* {{:helper.link(data.manual_control ? 'Engaged' : 'Disengaged', 'shuffle', { 'manual' : 1 }, null, data.manual_control ? 'selected' : null)}} */}
                  </div>
                </div>
              </fieldset>
            </div>
          </Section>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
