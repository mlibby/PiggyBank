function getTitle(vm) {
  const { title } = vm.$options;
  let returnTitle;
  if (title) {
    returnTitle = typeof title === 'function'
      ? title.call(vm)
      : title;
  } else {
    returnTitle = 'PiggyBank';
  }
  return returnTitle;
}

export default {
  created() {
    const title = getTitle(this);
    if (title) {
      document.title = title;
    }
  },
};
