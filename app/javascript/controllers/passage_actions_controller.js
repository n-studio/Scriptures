import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggleAnnotation(event) {
    const passageId = event.currentTarget.dataset.passageId
    const existing = document.getElementById(`annotation-form-${passageId}`)

    if (existing) {
      existing.remove()
      return
    }

    const form = document.createElement("form")
    form.id = `annotation-form-${passageId}`
    form.action = "/annotations"
    form.method = "post"
    form.className = "mt-3 space-y-2"

    const csrfToken = document.querySelector("meta[name='csrf-token']").content

    form.innerHTML = `
      <input type="hidden" name="authenticity_token" value="${csrfToken}">
      <input type="hidden" name="annotation[passage_id]" value="${passageId}">
      <textarea name="annotation[body]" placeholder="Add a note..." required
        class="w-full rounded-lg border border-stone-300 dark:border-stone-700 bg-white dark:bg-stone-900 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-stone-900 dark:focus:ring-stone-100 resize-none"
        rows="2"></textarea>
      <input type="text" name="annotation[tag_list]" placeholder="Tags (comma-separated)"
        class="w-full rounded-lg border border-stone-300 dark:border-stone-700 bg-white dark:bg-stone-900 px-3 py-1.5 text-xs focus:outline-none focus:ring-1 focus:ring-stone-900 dark:focus:ring-stone-100">
      <div class="flex gap-2">
        <button type="submit"
          class="px-3 py-1.5 rounded-md bg-stone-900 dark:bg-stone-100 text-white dark:text-stone-900 text-xs font-medium cursor-pointer">Save</button>
        <button type="button" onclick="this.closest('form').remove()"
          class="px-3 py-1.5 rounded-md text-xs text-stone-500 hover:text-stone-900 dark:hover:text-stone-100 cursor-pointer">Cancel</button>
      </div>
    `

    event.currentTarget.closest(".group").querySelector(".space-y-4, .flex-1").appendChild(form)
    form.querySelector("textarea").focus()
  }
}
