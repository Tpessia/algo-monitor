<template>
	<div class="result-id" :class="{ 'is-empty': !result }" v-if="fetched">
		<EmptyCard v-if="!result">
			<template v-slot:title>
				Id não encontrado
			</template>
		</EmptyCard>
		<div class="viewer-wrapper" v-else>
			<h3 class="id-title">Id: {{ id }}</h3>
			<JsonEditorSchema :jsonParams="result ? result : '{}'" :readOnly="true"/>
			<v-btn class="mt-5" color="primary" @click="downloadResult" :disabled="processing">Download</v-btn>
			<v-btn class="mt-5 ml-5" color="error" @click="deleteResult" :disabled="processing">Excluir</v-btn>
		</div>
	</div>
	<div class="loading" v-else>
		<v-progress-circular indeterminate :size="100" :width="2"/>
	</div>
</template>

<script lang="ts">
	import { Component, Vue } from 'vue-property-decorator';
    import EmptyCard from '@/components/EmptyCard.vue';
	import JsonEditorSchema from '@/components/JsonEditorSchema.vue';
	import axios from 'axios'

	@Component({
		components: {
            EmptyCard,
			JsonEditorSchema
		}
	})
	export default class ResultId extends Vue {
		private id!: string;
		private result: any = null;
		private fetched: boolean = false;
		private processing: boolean = false;

		async created() {
			this.id = this.$route.params.id;
			this.result = (await axios.get(`/api/results/id/${this.id}`)).data;
			this.fetched = true;
		}

		async downloadResult() {
			this.processing = true;
            try {
				// let success = await axios.get(`/api/results/download/id/${this.id}`).then(r => r.data);
				window.open(`/api/results/download/id/${this.id}`);
            } catch (error) {
				this.$toasted.show('Erro ao baixar resultado!', {
					type: 'error'
				}).goAway(2000);
            }
			this.processing = false;
		}

		async deleteResult() {
			this.processing = true;
			try {
				let success = (await axios.post('/api/results/delete/', {result_id: this.result['id']})).data;
				this.$toasted.show('Resultado excluído!').goAway(2000);
				this.$router.push({name: 'results'});
			}
			catch (error) {
				this.$toasted.show('Erro ao excluir resultado!', {
					type: 'error'
				}).goAway(2000);
			}
			this.processing = false;
		}
	}
</script>

<style lang="scss" scoped>
	.id-title {
		margin-bottom: 1.75rem;
	}

	.viewer-wrapper {
		button {
			margin-top: 10px;
		}
	}
</style>

