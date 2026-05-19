import { useState } from "react";
import "../styles/Recipes.css";


export default function Settings() {
    // Existing functionality
    const [recipeSuggestions, setRecipeSuggestions] = useState("");
    const [pageSuggestions, setPageSuggestions] = useState("");

    const handleRecipeSuggestionsChange = (e) => {
        setRecipeSuggestions(e.target.value);
    };

    const handlePageSuggestionsChange = (e) => {
        setPageSuggestions(e.target.value);
    };

    const handleSubmitRecipeSuggestions = () => {
        alert(`Recipe Suggestions submitted: ${recipeSuggestions}`);
        setRecipeSuggestions("");
    };

    const handleSubmitPageSuggestions = () => {
        alert(`Page review submitted: ${pageSuggestions}`);
        setPageSuggestions("");
    };

    // New Add Recipe functionality
    const [recipeTitle, setRecipeTitle] = useState("");
    const [recipeDescription, setRecipeDescription] = useState("");
    const [recipeCategory, setRecipeCategory] = useState("Breakfast");
    const [recipeIngredients, setRecipeIngredients] = useState("");
    const [recipeSteps, setRecipeSteps] = useState("");
    const [recipeImage, setRecipeImage] = useState("");

    const handleAddRecipe = () => {
        // Format the recipe details for display
        const ingredientsList = recipeIngredients.split("\n").filter(i => i.trim()).map((ing, idx) => `  ${idx + 1}. ${ing}`).join("\n");
        const stepsList = recipeSteps.split("\n").filter(s => s.trim()).map((step, idx) => `  ${idx + 1}. ${step}`).join("\n");
        
        const recipeDetails = `
╔════════════════════════════════════════╗
║       RECIPE DETAILS SUMMARY          ║
╚════════════════════════════════════════╝

📝 Title: ${recipeTitle}
📂 Category: ${recipeCategory}
📄 Description: ${recipeDescription}

🥘 INGREDIENTS:
${ingredientsList}

👨‍🍳 STEPS:
${stepsList}

${recipeImage ? `🖼️ Image URL: ${recipeImage}` : '🖼️ Image: Not provided'}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ℹ️  NOTE: This is a static demo site.
To permanently add this recipe:
1. Open src/data/details.json
2. Add this recipe to the "recipes" array
3. Commit and push the changes
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        `.trim();
        
        alert(recipeDetails);
        
        // Clear form
        setRecipeTitle("");
        setRecipeDescription("");
        setRecipeCategory("Breakfast");
        setRecipeIngredients("");
        setRecipeSteps("");
        setRecipeImage("");
    };

    return (
        <div>
            {/* Recipe Suggestions Section */}
            <div className="section d-block">
                <h2>Suggestions To Add New Recipe</h2>
                <div className="options-container">
                    <textarea
                        value={recipeSuggestions}
                        onChange={handleRecipeSuggestionsChange}
                        placeholder="Enter your suggestions here..."
                        rows="4"
                        className="suggestions-textarea"
                    ></textarea>
                </div>
                <div className="submit-container">
                    <button
                        className="submit-btn"
                        onClick={handleSubmitRecipeSuggestions}
                        disabled={!recipeSuggestions.trim()}
                    >
                        Submit
                    </button>
                </div>
            </div>

            {/* Page Suggestions Section */}
            <div className="section d-block">
                <h2>Review About The Page</h2>
                <div className="options-container">
                    <textarea
                        value={pageSuggestions}
                        onChange={handlePageSuggestionsChange}
                        placeholder="Enter your review here..."
                        rows="4"
                        className="suggestions-textarea"
                    ></textarea>
                </div>
                <div className="submit-container">
                    <button
                        className="submit-btn"
                        onClick={handleSubmitPageSuggestions}
                        disabled={!pageSuggestions.trim()}
                    >
                        Submit
                    </button>
                </div>
            </div>

            {/* Add Recipe Section */}
            
            <div className="add-recipe-section">
                <h2>Add a New Recipe</h2>
                <div className="form-container">
                    <input
                        type="text"
                        value={recipeTitle}
                        onChange={(e) => setRecipeTitle(e.target.value)}
                        placeholder="Recipe Title"
                        className="input-field"
                    />
                    <textarea
                        value={recipeDescription}
                        onChange={(e) => setRecipeDescription(e.target.value)}
                        placeholder="Recipe Description"
                        rows="2"
                        className="input-field"
                    ></textarea>
                    <select
                        value={recipeCategory}
                        onChange={(e) => setRecipeCategory(e.target.value)}
                        className="input-field"
                    >
                        <option value="Breakfast">Breakfast</option>
                        <option value="Lunch">Lunch</option>
                        <option value="Dinner">Dinner</option>
                        <option value="Snacks">Snacks</option>
                        <option value="Desserts">Desserts</option>
                    </select>
                    <textarea
                        value={recipeIngredients}
                        onChange={(e) => setRecipeIngredients(e.target.value)}
                        placeholder="Ingredients (one per line)"
                        rows="4"
                        className="input-field"
                    ></textarea>
                    <textarea
                        value={recipeSteps}
                        onChange={(e) => setRecipeSteps(e.target.value)}
                        placeholder="Steps (one per line)"
                        rows="4"
                        className="input-field"
                    ></textarea>
                    <input
                        type="text"
                        value={recipeImage}
                        onChange={(e) => setRecipeImage(e.target.value)}
                        placeholder="Image URL (optional)"
                        className="input-field"
                    />
                    <button
                        className="submit-btn"
                        onClick={handleAddRecipe}
                        disabled={
                            !recipeTitle.trim() ||
                            !recipeDescription.trim() ||
                            !recipeIngredients.trim() ||
                            !recipeSteps.trim()
                        }
                    >
                        Add Recipe
                    </button>
                </div>
            </div>
        </div>
    );
}
