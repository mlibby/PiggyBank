import Vue from 'vue';
import VueRouter from 'vue-router';
import Home from '../views/Home.vue';
import Amortization from '../views/tools/Amortization.vue';

Vue.use(VueRouter);

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home,
  },
  {
    path: '/tools/amortization',
    name: 'Amortization',
    component: Amortization,
  },
];

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes,
});

router.afterEach((to, from) => {
  document.activeElement.blur();
});

export default router;
