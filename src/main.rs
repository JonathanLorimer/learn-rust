use std::io;
use std::cmp::Ordering;
use rand::Rng;
mod ownership;
mod slice_type;

fn main() {
    // guessing_game();
    let s = String::from("hello world");
    let fw = slice_type::first_word(&s);
    println!("{}", fw);
}

fn guessing_game() {
    println!("Guess the number!");

    let secret_number = rand::thread_rng().gen_range(1..101);

    loop {
        println!("Please input your guess!");

        let mut guess = String::new();

        io::stdin()
            .read_line(&mut guess)
            .expect("Failed to read line");

        let guess: u32 = match guess.trim().parse() {
            Ok(num) => num,
            Err(_) => continue,
        };

        match guess.cmp(&secret_number) {
            Ordering::Less => println!("Too small!"),
            Ordering::Greater => println!("Too large!"),
            Ordering::Equal => {
                println!("You nailed it");
                break;
            },
        };
    }
}
