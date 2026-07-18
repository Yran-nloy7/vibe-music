import { createApp } from 'vue'
import App from './App.vue'
import router from './routers/index'
import Store from '@/stores'
import ElementPlus from 'element-plus'
import zhCn from 'element-plus/dist/locale/zh-cn.mjs'
import 'element-plus/dist/index.css'
import 'element-plus/theme-chalk/dark/css-vars.css'
import './style/index.scss'

// 🏝️ Animal Island Vue UI
import {
  Button as AnimalButton,
  Card as AnimalCard,
  Title as AnimalTitle,
  Divider as AnimalDivider,
  Icon as AnimalIcon,
  Collapse as AnimalCollapse,
  Time as AnimalTime
} from 'animal-island-vue'
import 'animal-island-vue/style'

const app = createApp(App)

// 路由
app.use(router)
// 状态管理
app.use(Store)
// ElementPlus
app.use(ElementPlus, {
  locale: zhCn,
})
// 🏝️ Animal Island 组件注册
app.component('AnimalButton', AnimalButton)
app.component('AnimalCard', AnimalCard)
app.component('AnimalTitle', AnimalTitle)
app.component('AnimalDivider', AnimalDivider)
app.component('AnimalIcon', AnimalIcon)
app.component('AnimalCollapse', AnimalCollapse)
app.component('AnimalTime', AnimalTime)

app.mount('#app')
