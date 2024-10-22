import axios from 'axios'

const isProd = import.meta.env.MODE === 'production'
const envUrl = import.meta.env.VITE_API_URL

export const instance = axios.create({
  baseURL:
    envUrl ||
    (isProd ? 'http://35.226.221.251:4001/api' : 'http://localhost:4005/api'),
  headers: {
    'Content-Type': 'application/json'
  }
})

instance.interceptors.request.use(
  config => {
    const token = localStorage.getItem('time-manager-token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  error => {
    return Promise.reject(error)
  }
)
