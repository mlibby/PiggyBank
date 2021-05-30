<template>
    <div class="spinner">
        <div v-if="loading">
            <img src="../assets/spin_primary.svg" />
        </div>
        <div v-else>
            <slot></slot>
            <div v-if="errorMessage" class="error">
                <span class="icon icon-warning">
                    <span class="sr-only"> Error: </span>
                </span>
                {{ errorMessage }}
            </div>
        </div>
    </div>
</template>

<script>
export default {
    name: "SpinnerDiv",
    data() {
        return {
            loading: true,
            errorMessage: null,
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
                this.loading = false;
            };
            const error = (e) => {
                this.loading = false;
                this.errorMessage = e.message;
                if (
                    e.response &&
                    e.response.data &&
                    !e.response.data.startswith("<!DOCTYPE")
                ) {
                    this.errorMessage = e.response.data;
                }
            };
            this.onLoad(next, error);
        },
    },
};
</script>
