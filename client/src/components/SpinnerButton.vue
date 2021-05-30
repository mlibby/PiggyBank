<template>
    <button
        :style="{ width: buttonWidth + 'px' }"
        ref="thisButton"
        v-on:click="buttonClick"
    >
        <span :style="{ display: textDisplay }">
            <slot>[button]</slot>
        </span>
        <img src="../assets/spin.svg" :style="{ display: imgDisplay }" />
    </button>
</template>

<script>
export default {
    name: "SpinnerButton",
    props: {
        onClick: {
            type: Function,
            required: true,
        },
    },
    data: function () {
        return {
            buttonWidth: "auto",
            imgDisplay: "none",
            text: "[anonymous button]",
            textDisplay: "inline",
        };
    },
    methods: {
        // Yes, this manages the display styles "by hand" rather than
        // using Vue directives like v-if. I think I was having
        // trouble with the built-ins. Maybe they'd work now?
        buttonClick: function (event) {
            event.preventDefault();
            const button = this.$refs.thisButton;
            button.disabled = true;
            button.style.width = button.offsetWidth + 0.5 + "px";
            this.textDisplay = "none";
            this.imgDisplay = "inline-block";
            const next = () => {
                button.disabled = false;
                this.textDisplay = "inline";
                this.imgDisplay = "none";
            };
            this.onClick(next);
        },
    },
};
</script>

<style>
button img {
    height: 1.33rem;
    margin: -0.33rem;
    padding: 0;
    text-align: center;
}
</style>
