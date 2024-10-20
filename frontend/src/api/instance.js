import axios from 'axios'

const PORT = import.meta.env.PROD ? 4001 : 4000

export const instance = axios.create({
  baseURL: `http://localhost:${PORT}/api`,
  headers: {
    'Content-Type': 'application/json'
  }
})
