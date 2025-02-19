import { css } from "uebersicht";

export const command = 'date "+%A the %dth, %H:%M"';

export const refreshFrequency = 30000; // ms

export const className = `
  left: 29vw;
  bottom: 59.5vh;
`;

const content = css`
  font-family:
    Polsyh,
    Comic Sans MS;
  font-size: 2vw;
  font-weight: normal;
  color: #000;
  text-align: center;
`;

export const render = ({ output }) => (
  <div>
    <h1 className={content}>Captain, it's {output}</h1>
  </div>
);
