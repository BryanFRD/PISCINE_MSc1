import axios from 'axios'

export const instance = axios.create({
  baseURL: process.env.VUE_API_URL || 'http://localhost:4000/api',
  headers: {
    'Content-Type': 'application/json'
  }
})
