import { css } from "uebersicht";

export const command = 'date "+%H:%M on %A the %dth"';

export const refreshFrequency = 30000; // ms

export const className = `
  left: 750px;
  bottom: 860px;
`;

const content = css`
  font-family:
    Polsyh,
    Comic Sans MS;
  font-size: 50px;
  font-weight: normal;
  color: #000;
  text-align: left;
`;

export const render = ({ output }) => (
  <div>
    <h1 className={content}>Captain, it's {output}</h1>
  </div>
);
