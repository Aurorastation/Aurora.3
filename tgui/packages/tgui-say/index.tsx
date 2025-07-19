import './styles/main.scss';
import { render } from 'react';

import { TguiSay } from './TguiSay';

document.onreadystatechange = function () {
  if (document.readyState !== 'complete') return;

  const root = document.getElementById('react-root');
  render(<TguiSay />, root);
};
