import { useState } from "react";
import { useNavigate } from "react-router-dom";
import "../styles/Recipes.css";


export default function Settings() {
    const navigate = useNavigate();
    
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
        // Create the new recipe object
        const newRecipe = {
            id: Date.now().toString(36) + Math.random().toString(36).substr(2),
            title: recipeTitle,
            description: recipeDescription,
            category: recipeCategory,
            ingredients: recipeIngredients.split("\n").filter(i => i.trim()),
            steps: recipeSteps.split("\n").filter(s => s.trim()),
            image: recipeImage || "/img/gallery/img_1.jpg"
        };

        // Get existing user recipes from localStorage
        const existingRecipes = JSON.parse(localStorage.getItem("userRecipes") || "[]");
        
        // Add new recipe
        existingRecipes.unshift(newRecipe); // Add to beginning of array
        
        // Save back to localStorage
        localStorage.setItem("userRecipes", JSON.stringify(existingRecipes));
        
        // Format the recipe details for display
        const ingredientsList = newRecipe.ingredients.map((ing, idx) => `  ${idx + 1}. ${ing}`).join("\n");
        const stepsList = newRecipe.steps.map((step, idx) => `  ${idx + 1}. ${step}`).join("\n");
        
        const recipeDetails = `
╔════════════════════════════════════════╗
║    RECIPE ADDED SUCCESSFULLY! ✓       ║
╚════════════════════════════════════════╝

📝 Title: ${recipeTitle}
📂 Category: ${recipeCategory}
📄 Description: ${recipeDescription}

🥘 INGREDIENTS:
${ingredientsList}

👨‍🍳 STEPS:
${stepsList}

${recipeImage ? `🖼️ Image URL: ${recipeImage}` : '🖼️ Image: Default image used'}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Your recipe has been saved!
   Go to Recipes page to view it.
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
        
        // Ask if user wants to view recipes
        if (window.confirm("Would you like to view your recipe now?")) {
            navigate("/recipes");
        }
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
