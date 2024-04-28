import { NoticeBox } from 'tgui/components';

type MinimapViewProps = {
  map_image: any; // base64 icon
  x: number;
  y: number;
};

export const MinimapView = (props: MinimapViewProps) => {
  const map_size = 255;
  const zoom_mod = 2.0;
  const center_point_x = props.x;
  const center_point_y = props.y;
  return props.map_image ? (
    <svg
      height={'250px'}
      width={'100%'}
      viewBox={`0 0 ${map_size} ${map_size}`}
      overflow={'hidden'}>
      <g
        transform={`translate(
          ${(map_size * (zoom_mod - 1.0)) / -2 + (255 / 2 - center_point_x)}
          ${
            (map_size * (zoom_mod - 1.0)) / -2 +
            (255 / 2 - (map_size - center_point_y))
          }
        )`}>
        <image
          width={map_size * zoom_mod}
          height={map_size * zoom_mod}
          xlinkHref={`data:image/jpeg;base64,${props.map_image}`}
        />
        <polygon
          points="3,0 0,3 -3,0 0,-3"
          fill="#FF0000"
          stroke="#FFFF00"
          stroke-width="0.5"
          transform={`translate(
                ${center_point_x * zoom_mod}
                ${(map_size - center_point_y) * zoom_mod}
              )`}
        />
        <circle
          r={16}
          cx={0}
          cy={0}
          fill="none"
          stroke="#FF0000"
          stroke-width="1"
          transform={`translate(
                ${center_point_x * zoom_mod}
                ${(map_size - center_point_y) * zoom_mod}
              )`}
        />
        <rect
          x={-24}
          y={-24}
          width={48}
          height={48}
          stroke="red"
          stroke-width="1"
          fill="none"
          transform={`translate(
              ${center_point_x * zoom_mod}
              ${(map_size - center_point_y) * zoom_mod}
            )`}
        />
        <text
          x="26"
          y="-8"
          text-anchor="left"
          fill="red"
          font-size="12"
          transform={`translate(
              ${center_point_x * zoom_mod}
              ${(map_size - center_point_y) * zoom_mod}
            )`}>
          {props.x}
        </text>
        <text
          x="26"
          y="8"
          text-anchor="left"
          fill="red"
          font-size="12"
          transform={`translate(
              ${center_point_x * zoom_mod}
              ${(map_size - center_point_y) * zoom_mod}
            )`}>
          {props.y}
        </text>
      </g>
    </svg>
  ) : (
    <NoticeBox warning>No scan image available.</NoticeBox>
  );
};
