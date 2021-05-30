<template>
    <div class="spinner">
        <div v-if="loading">
            <img src="../assets/spin_primary.svg" />
        </div>
        <div v-else>
            <slot></slot>
        </div>
        <div v-if="error" class="error">
            <span class="icon icon-warning">
                <span class="sr-only"> Error: </span>
            </span>
            {{ error }}
        </div>
    </div>
</template>

<script>
export default {
    name: "SpinnerDiv",
    data() {
        return {
            loading: true,
            error: null,
        };
    },
    props: {
        onLoad: {
            type: Function,
            required: true,
        },
    },
    methods: {
        load: function () {
            const next = () => {
                button.disabled = false;
                this.textDisplay = "inline";
                this.imgDisplay = "none";
            };
            const error = (e) => {
                this.loading = false;
                this.error =
                    error.response && error.response.data
                        ? error.response.data
                        : error.message;
            };
            this.onLoad(next, error);
        },
    },
};
</script>
