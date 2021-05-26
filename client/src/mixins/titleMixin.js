function getTitle(vm) {
    const { title } = vm.$options;
    let thisTitle;
    if (title) {
        return typeof title === "function"
            ? title.call(vm)
            : `${title} : PiggyBank`;
    } else {
        return "PiggyBank";
    }
}

export default {
    created() {
        const title = getTitle(this);
        if (title) {
            document.title = title;
        }
    },
};
