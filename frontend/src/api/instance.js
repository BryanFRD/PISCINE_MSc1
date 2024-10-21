import axios from 'axios'

export const instance = axios.create({
  baseURL: import.meta.env.VITE_API_URL || 'http://localhost:4005/api',
  headers: {
    'Content-Type': 'application/json'
  }
})
