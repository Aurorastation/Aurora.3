pub mod core;
pub mod tools;

pub use core::GridMap;

#[cfg(test)]
mod test;

pub fn mapmanip(dmm_path: &std::path::Path, config_path: &std::path::Path) -> Option<GridMap> {
    todo!() //
}
