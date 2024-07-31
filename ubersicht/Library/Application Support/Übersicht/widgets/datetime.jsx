import { css } from "uebersicht"

export const command = "date \"+%a %F %H:%M\""

export const refreshFrequency = 30000 // ms

export const className = `
  left: 40px;
  bottom: 10px;
`

const content = css`
  font-family: Curse of the Zombie, Impact;
  font-size: 90px;
  font-weight: normal;
  color: #000;
  text-align: left;
`

export const render = ({ output }) => (
  <div>
    <h1 className={content}>{output.toUpperCase()}</h1>
  </div>
)

